import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'base_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailFormField extends StatelessWidget {
  final void Function(String?, bool) onChange;
  final void Function(String)? onFieldSubmitted;
  final String? initialValue;
  final bool enabled;

  const EmailFormField({
    super.key,
    this.initialValue,
    this.onFieldSubmitted,
    required this.onChange,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return BaseTextFormField(
      enabled: enabled,
      fieldValue: initialValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixIcon: const Icon(
          CupertinoIcons.envelope,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        labelText: t.emailLinkText,
        labelStyle: GoogleFonts.quicksand(
          color: const Color.fromARGB(255, 190, 190, 190),
          fontSize: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return t.emailEmptyErrorMessage;
        }
        final emailRegex = RegExp(r'^[\w-zñ\.]+@([\w-zñ]+\.)+[\w-z]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return t.emailInvalidFormatErrorMessage;
        }
        return null;
      },
      onChange: (String? value, bool isValid) {
        onChange(value?.toLowerCase(), isValid);
      },
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
