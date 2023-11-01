import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatePickerField extends StatefulWidget {
  final Function onChange;
  final DateTime? initialValue;

  const DatePickerField({
    Key? key,
    required this.onChange,
    this.initialValue,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePickerField> {
  final TextEditingController _date = TextEditingController();
  DateTime currentDate = DateTime.now();
  late DateTime dateCenturyAgo;
  DateTime? pickedDate;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _date.text = widget.initialValue == null
        ? ''
        : DateFormat('dd-MM-yyyy').format(widget.initialValue!);
    dateCenturyAgo = currentDate.subtract(
      const Duration(days: 365 * 100),
    );
    pickedDate = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    InputDecoration defaultDecoration = _buildDefaultDecoration();

    return TextFormField(
      readOnly: true,
      style: GoogleFonts.quicksand(),
      controller: _date,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: const Icon(
          CupertinoIcons.calendar,
          color: Colors.grey,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: Colors.white,
        focusedErrorBorder: defaultDecoration.focusedErrorBorder,
        errorBorder: defaultDecoration.errorBorder,
        focusedBorder: defaultDecoration.focusedBorder,
        enabledBorder: defaultDecoration.enabledBorder,
        labelText: pickedDate == null
            ? t.birthdateLabelLinkText
            : DateFormat('dd-MM-yyyy').format(pickedDate!),
        border: defaultDecoration.border,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return t.enterBirthdateLinkText;
        }

        final birthday = DateFormat('dd-MM-yyyy').parse(value);
        int age = currentDate.year - birthday.year;
        if (currentDate.month < birthday.month ||
            (currentDate.month == birthday.month &&
                currentDate.day < birthday.day)) {
          age--;
        }

        if (age <= 18) {
          hasError = true;
          return t.mustBeOlderErrorLinkText;
        }

        hasError = false;
        return null;
      },
      onTap: () async {
        pickedDate = await showDatePicker(
          context: context,
          initialDate: pickedDate ?? currentDate,
          firstDate: dateCenturyAgo,
          lastDate: currentDate,
          builder: (context, child) => Theme(
            data: ThemeData(
              dialogTheme: const DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
              ),
            ).copyWith(
              dialogBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
              textTheme: TextTheme(
                displayLarge: GoogleFonts.quicksand(), // no aplica
                displayMedium: GoogleFonts.quicksand(), // no aplica
                displaySmall: GoogleFonts.quicksand(), // no aplica
                headlineMedium: GoogleFonts.quicksand(),
                headlineSmall: GoogleFonts.quicksand(), // no aplica
                titleMedium: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 18,
                ), // controla: título y fecha seleccionada en mod. 2
                titleSmall: GoogleFonts.quicksand(),
                bodyLarge: GoogleFonts.quicksand(), // no aplica
                bodyMedium: GoogleFonts.quicksand(), // no aplica
                bodySmall: GoogleFonts.quicksand(
                  fontSize: 14,
                ), // controla: numeros de fecha del calendario mod. 1
                labelLarge: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                ), // controla: botones de aceptar y cancelar mod. 1 y mod. 2
                labelSmall: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ), // controla: seleccionar fecha mod. 1 y mod. 2
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.black,
                    surface: Colors.black,
                    onPrimary: Colors.white,
                    onSurface: Colors.white,
                  ),
            ),
            child: child!,
          ),
        );
        if (pickedDate != null) {
          setState(() {
            _date.text = DateFormat('dd-MM-yyyy').format(pickedDate!);
            int age = getAge();
            widget.onChange(age, pickedDate!);
          });
        }
      },
      onChanged: (value) {
        if (hasError) {
          setState(() {
            hasError = false;
          });
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (value) {
        setState(() {
          hasError = true;
        });
      },
    );
  }

  int getAge() {
    if (_date.text.isNotEmpty) {
      final birthday = DateFormat('dd-MM-yyyy').parse(_date.text);
      int age = currentDate.year - birthday.year;
      if (currentDate.month < birthday.month ||
          (currentDate.month == birthday.month &&
              currentDate.day < birthday.day)) {
        age--;
      }
      return age;
    } else {
      return 0;
    }
  }

  InputDecoration _buildDefaultDecoration() {
    OutlineInputBorder defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.5),
      borderSide: const BorderSide(
        width: 0.8,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
    return InputDecoration(
      border: defaultBorder,
      enabledBorder: defaultBorder,
      focusedBorder: defaultBorder,
      errorBorder: defaultBorder,
      focusedErrorBorder: defaultBorder,
    );
  }
}
