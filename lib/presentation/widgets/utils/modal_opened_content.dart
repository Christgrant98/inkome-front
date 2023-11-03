import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inkome_front/presentation/widgets/utils/custom_bottom_modal.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:inkome_front/data/models/advert.dart';
import 'package:inkome_front/presentation/widgets/utils/modal_view.dart';
import 'package:inkome_front/presentation/widgets/utils/custom_button.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalOpenedContainerContent extends StatefulWidget {
  final Advert advert;
  final String location;
  final String availability;
  final String rate;

  const ModalOpenedContainerContent({
    Key? key,
    required this.advert,
    this.location = 'Medellin',
    this.availability = '24 horas',
    this.rate = '4.5',
  }) : super(key: key);

  @override
  State<ModalOpenedContainerContent> createState() =>
      _ModalOpenedContainerContentState();
}

class _ModalOpenedContainerContentState
    extends State<ModalOpenedContainerContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomBottomModal(
          height: !_isExpanded
              ? screenHeight * .2
              : widget.advert.adTags != null && widget.advert.adTags!.isNotEmpty
                  ? screenHeight * .425
                  : screenHeight * .325,
          content: _buildBody(isLargeScreen, context),
        ),
      ],
    );
  }

  Widget _buildBody(bool isLargeScreen, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: _buildHeader(),
                    ),
                  ),
                  IconButton(
                      onPressed: () => setState(() {
                            _isExpanded = !_isExpanded;
                          }),
                      icon: Icon(
                        _isExpanded
                            ? Icons.arrow_drop_down_rounded
                            : Icons.arrow_drop_up_rounded,
                        size: 30,
                      ))
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                indent: 25,
                endIndent: 25,
                color: Colors.black,
                thickness: 0.7,
              ),
              if (_isExpanded) _buildExpandedContent(isLargeScreen),
            ],
          ),
        ),
        const SizedBox(height: 15),
        CustomButton(
          text: formatPhoneNumber(widget.advert.phoneNumber),
          borderRadius: 15,
          fontSize: 20,
          height: 55,
          width: 250,
          onPressed: () async {
            await _performCallEvent(context);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildExpandedContent(bool isLargeScreen) {
    return Column(
      children: [
        if (widget.advert.adTags != null && widget.advert.adTags!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: isLargeScreen ? 8 : -2.5,
              children: widget.advert.adTags!.map((tag) {
                return Chip(
                  backgroundColor: Colors.black,
                  label: TextView(
                    text: tag,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        Container(
          padding:
              const EdgeInsets.only(top: 15, left: 35, right: 35, bottom: 15),
          child: TextView(
            text: widget.advert.description,
            fontSize: 16,
            color: Colors.black,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarqueeText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                text: widget.advert.name,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const TextView(
                text: 'Barranquilla', color: Colors.black, fontSize: 12),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              TextView(text: '4.5', color: Colors.black, fontSize: 14),
              SizedBox(width: 2.5),
              Icon(color: Colors.yellow, size: 12, CupertinoIcons.star_fill),
            ],
          ),
        ),
        TextView(
            text: '${widget.advert.age} años',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 12),
        const TextView(
          text: '24 horas',
          color: Colors.black,
          fontSize: 12,
        ),
      ],
    );
  }

  Future<void> _performCallEvent(BuildContext context) async {
    if (!kIsWeb) {
      final Uri url = Uri(
          scheme: 'tel', path: formatPhoneNumber(widget.advert.phoneNumber));
      if (await canLaunchUrl(url)) {
        launchUrl(url);
      } else {
        const Center(
            child: TextView(
          text: ' cannot launch assigned value ',
          color: Colors.white,
        ));
      }
    } else {
      Clipboard.setData(
        ClipboardData(
          text: formatPhoneNumber(widget.advert.phoneNumber),
        ),
      );
      showCopiedNumber(context);
    }
  }

  void showCopiedNumber(context) => showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            Navigator.of(context).pop();
          });

          return StatefulBuilder(
            builder: (context, setState) {
              return const ModalView(
                content: Column(
                  children: [
                    TextView(
                      text: 'Número de teléfono copiado',
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    TextView(
                      fontSize: 13.5,
                      text:
                          'El número de teléfono se ha copiado al portapapeles.',
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

  String formatPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^(\d{3})(\d{3})(\d{4})$');
    final match = regex.firstMatch(phoneNumber);

    if (match != null) {
      final group1 = match.group(1);
      final group2 = match.group(2);
      final group3 = match.group(3);

      return '$group1 $group2 $group3';
    } else {
      return phoneNumber;
    }
  }
}
