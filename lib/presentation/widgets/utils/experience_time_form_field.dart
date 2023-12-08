import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExperienceTimeFormField extends StatefulWidget {
  final int minExpTime;
  final int maxExpTime;
  final Function onChange;
  final String? label;
  final String? expercienceTime;
  final int? initialValue;

  const ExperienceTimeFormField({
    super.key,
    required this.onChange,
    this.minExpTime = 1,
    this.maxExpTime = 20,
    this.label,
    this.initialValue,
    this.expercienceTime,
  });

  @override
  State<StatefulWidget> createState() => _SliderInputState();
}

class _SliderInputState extends State<ExperienceTimeFormField> {
  late int sliderValue;

  @override
  void initState() {
    bool inRange = widget.initialValue == null
        ? false
        : widget.initialValue! >= widget.minExpTime &&
            widget.initialValue! <= widget.maxExpTime;
    if (inRange) {
      sliderValue = widget.initialValue!;
    } else {
      sliderValue = widget.minExpTime;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return Column(
      children: [
        const TextView(
          text: 'Years of experience',
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        if (widget.expercienceTime != null)
          TextView(
            text: widget.expercienceTime,
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        Slider(
          thumbColor: Colors.black,
          activeColor: const Color.fromARGB(255, 105, 105, 105),
          value: sliderValue.toDouble(),
          min: widget.minExpTime.toDouble(),
          max: widget.maxExpTime.toDouble(),
          divisions: widget.maxExpTime - widget.minExpTime,
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
