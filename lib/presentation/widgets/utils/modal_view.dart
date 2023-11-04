import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModalView extends StatelessWidget {
  final Widget? content;
  final void Function()? onClose;
  final double? widthFactor;
  final double? heightFactor;
  final double? borderRadius;
  final double? paddingValue;

  const ModalView({
    Key? key,
    this.content,
    this.onClose,
    this.widthFactor = 0.9,
    this.heightFactor = 1,
    this.borderRadius = 12,
    this.paddingValue = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception("AppLocalizations not found");

    return _buildContent(t);
  }

  Widget _buildContent(AppLocalizations t) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: Container(
          padding: EdgeInsets.all(paddingValue!),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius!),
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: content != null
              ? Material(
                  color: Colors.transparent,
                  child: content!,
                )
              : Container(),
        ),
      ),
    );
  }
}
