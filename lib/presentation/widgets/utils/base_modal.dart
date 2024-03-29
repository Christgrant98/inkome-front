import 'dart:ui';

import 'package:flutter/material.dart';

class BaseModal extends StatelessWidget {
  static Future<void> open(
      {required BuildContext context,
      required List<Widget> children,
      Widget? title}) {
    return showDialog<void>(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext context) {
        return BaseModal(
          title: title,
          children: children,
        );
      },
    );
  }

  final Widget? title;
  final List<Widget> children;

  const BaseModal({Key? key, this.title, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        content: SingleChildScrollView(
          child: SizedBox(
            child: ListBody(children: children),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
