import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/data/models/advert.dart';
import 'package:inkome_front/logic/cubits/adverts.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/presentation/forms/login_form.dart';
import 'package:inkome_front/presentation/router/app_router.dart';
import 'package:inkome_front/presentation/widgets/utils/modal_view.dart';
import 'package:inkome_front/presentation/widgets/utils/base_modal.dart';
import 'package:inkome_front/presentation/widgets/utils/fav_icon_container.dart';
import 'package:inkome_front/presentation/widgets/utils/image_swiper.dart';
import 'package:inkome_front/presentation/widgets/utils/modal_closed_content.dart';
import 'package:inkome_front/presentation/widgets/utils/modal_opened_content.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class AdvertPreview extends StatefulWidget {
  final double width;
  final Advert advert;

  const AdvertPreview({super.key, required this.width, required this.advert});

  @override
  State<AdvertPreview> createState() => _AdvertPreviewState();
}

class _AdvertPreviewState extends State<AdvertPreview> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BaseModal.open(
          context: context,
          children: [
            InkWell(
              child: _buildModalOpenedContent(context),
              onTap: () {
                _showContentBottomSheet(context);
              },
            ),
          ],
        );
        _showContentBottomSheet(context);
      },
      child: _buildModalClosedContent(context),
    );
  }

  Widget _buildModalOpenedContent(BuildContext context) {
    String? token = context.read<AuthenticationCubit>().state.token;
    double screenWidth = MediaQuery.of(context).size.width;
    double desktopScreen = screenWidth * 0.3;
    double mobileScreen = screenWidth;
    double desiredWidth = screenWidth > 800 ? desktopScreen : mobileScreen;

    return Stack(
      children: [
        Column(
          children: [
            if (widget.advert.images.length == 1)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Image.memory(
                  widget.advert.images.first,
                  fit: BoxFit.cover,
                ),
              ),
            if (widget.advert.images.length > 1)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: desiredWidth,
                  child: ImageSlider(
                    images: widget.advert.images,
                  ),
                ),
              ),
          ],
        ),
        _buildActionButtonsContentOpened(token, context),
      ],
    );
  }

  Widget _buildActionButtonsContentOpened(
    String? token,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FavIconContainer(
            size: 40,
            isSquare: true,
            selected: widget.advert.isFav,
            onTap: () {
              if (token == null) {
                showLoginDialog(context);
                return;
              }
              context
                  .read<AdvertsCubit>()
                  .toggleAdvertFav(widget.advert, token);
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              CupertinoIcons.xmark_square_fill,
              size: 50,
              shadows: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 2), blurRadius: 5.0)
              ],
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalClosedContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Center(
        child: SizedBox(
          width: widget.width,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 9 / 15.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.advert.images.isEmpty
                      ? Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZNQZI9chyqtlvn6KNfid_ACsf4O-NiKn9Cw&usqp=CAU',
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          widget.advert.images.first,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: FavIconContainer(
                  selected: widget.advert.isFav,
                  onTap: () {
                    String? token =
                        context.read<AuthenticationCubit>().state.token;
                    if (token == null) {
                      showLoginDialog(context);
                      return;
                    }
                    context
                        .read<AdvertsCubit>()
                        .toggleAdvertFav(widget.advert, token);
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ModalClosedContainerContent(
                  advert: widget.advert,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContentBottomSheet(context) => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ModalOpenedContainerContent(
          advert: widget.advert,
        ),
      );

  void showLoginDialog(context) => showDialog(
        context: context,
        builder: (context) {
          Future.delayed(
            const Duration(minutes: 1),
            () {
              Navigator.of(context).pop();
            },
          );
          return ModalView(
            content: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      CupertinoIcons.xmark_square_fill,
                      shadows: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 2),
                            blurRadius: 5.0)
                      ],
                      size: 32.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const TextView(
                  fontSize: 14,
                  text: 'Accede para marcar como favorito!',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // height: 140,
                  width: 140,
                  child: Image.asset('sqr_logo.png'),
                ),
                SizedBox(
                  height: 240,
                  width: 400,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          const LoginForm(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TextView(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  text: '¿No tienes una cuenta?'),
                              // SizedBox(height: 15),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, Routes.registrationPage),
                                child: const TextView(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  text: 'Registrate',
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
}
