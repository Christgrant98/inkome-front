import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExperienceTimeFormField extends StatefulWidget {
  final int minAge;
  final int maxAge;
  final Function onChange;
  final String? label;
  final String? ageToShow;
  final int? initialValue;

  const ExperienceTimeFormField(
      {super.key,
      required this.onChange,
      this.minAge = 18,
      this.maxAge = 65,
      this.label,
      this.initialValue,
      this.ageToShow});

  @override
  State<StatefulWidget> createState() => _SliderInputState();
}

class _SliderInputState extends State<ExperienceTimeFormField> {
  late int sliderValue;

  @override
  void initState() {
    bool inRange = widget.initialValue == null
        ? false
        : widget.initialValue! >= widget.minAge &&
            widget.initialValue! <= widget.maxAge;
    if (inRange) {
      sliderValue = widget.initialValue!;
    } else {
      sliderValue = widget.minAge;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return Column(
      children: [
        TextView(
          text: t.selectYourAgeLinkText,
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        if (widget.ageToShow != null)
          TextView(
            text: widget.ageToShow,
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        Slider(
          thumbColor: Colors.black,
          activeColor: const Color.fromARGB(255, 105, 105, 105),
          value: sliderValue.toDouble(),
          min: widget.minAge.toDouble(),
          max: widget.maxAge.toDouble(),
          divisions: widget.maxAge - widget.minAge,
          label: sliderValue.toString(),
          onChanged: _onChange,
        ),
      ],
    );
  }

  void _onChange(double value) {
    int val = value.toInt();
    setState(() {
      sliderValue = val;
      widget.onChange(val);
    });
  }
}
