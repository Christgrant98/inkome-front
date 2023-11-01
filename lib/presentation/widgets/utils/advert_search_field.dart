import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertSearchField extends StatefulWidget {
  final Function(String, bool)? onChange;
  final String? searchText;
  final int debounce;

  const AdvertSearchField({
    Key? key,
    this.onChange,
    this.searchText,
    this.debounce = 1000,
  }) : super(key: key);

  @override
  State<AdvertSearchField> createState() => _AdvertSearchFieldState();
}

class _AdvertSearchFieldState extends State<AdvertSearchField> {
  late TextEditingController _textEditingController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.searchText);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      itemColor: Colors.black,
      controller: _textEditingController,
      style: GoogleFonts.quicksand(
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      onChanged: (value) {
        if (widget.onChange == null) return;
        if (_timer != null && _timer!.isActive) _timer!.cancel();
        _timer = Timer(
          Duration(milliseconds: widget.debounce),
          () => widget.onChange!(value, true),
        );
      },
    );
  }
}
