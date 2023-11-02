import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/base_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NameFormField extends StatelessWidget {
  final void Function(String?, bool) onChange;
  final String? initialValue;
  final void Function(String)? onFieldSubmitted;
  const NameFormField({
    super.key,
    required this.onChange,
    this.initialValue,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return BaseTextFormField(
        fieldValue: initialValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: const Icon(
            CupertinoIcons.person,
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: t.nameLinkText,
        ),
        onChange: onChange,
        onFieldSubmitted: onFieldSubmitted,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return t.nameValidCompleteLinkText;
          }
          final nameRegExp = RegExp(
              r"^\s*([A-Za-z][A-Za-zñÑ]*(?:\s+[A-Za-z][A-Za-zñÑ]*)*\.?\s*)$");
          if (!nameRegExp.hasMatch(value)) {
            return t.nameValidLinkText;
          }
          return null;
        });
  }
}
