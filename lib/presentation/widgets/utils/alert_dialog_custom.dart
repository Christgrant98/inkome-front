import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/custom_button.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? titleText;
  final String? contentText;
  final bool hasButton;
  final Widget? content;
  final VoidCallback? onButtonPressed;
  final String? buttonText;
  final Widget? header;
  final List<Widget>? actions;

  const CustomAlertDialog({
    Key? key,
    this.titleText,
    this.contentText,
    this.hasButton = true,
    this.onButtonPressed,
    this.buttonText,
    this.content,
    this.header,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        title: header ??
            TextView(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF0000),
              text: titleText,
            ),
        content: content ??
            TextView(
              color: Colors.white,
              text: contentText,
            ),
        actions: actions ?? _buildActions(context),
      ),
    );
  }

  // es un List porque cubre el parametro de actions que es un array.
  List<Widget> _buildActions(BuildContext context) {
    if (hasButton) {
      return [
        CustomButton(
          borderRadius: 15,
          text: buttonText ?? 'Aceptar',
          onPressed: onButtonPressed ??
              () {
                Navigator.of(context).pop();
              },
        ),
      ];
    } else {
      return [];
    }
  }
}
