import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final Function onChange;
  final DateTime? initialValue;
  final String? fieldValue;

  const DatePickerField({
    Key? key,
    required this.onChange,
    this.initialValue,
    this.fieldValue,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePickerField> {
  final TextEditingController _date = TextEditingController();
  DateTime currentDate = DateTime.now();
  late DateTime dateCenturyAgo;
  DateTime? pickedDate;
  bool hasError = false;
  DateTime? lastSelectedDate;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _date.text = widget.fieldValue ?? '';
    dateCenturyAgo = currentDate.subtract(
      const Duration(days: 365 * 100),
    );
    selectedDate = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.fieldValue,
      readOnly: true,
      style: GoogleFonts.quicksand(),
      controller: _date,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFFFF0000),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFFFF0000),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFFFF0000),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFFFF0000),
          ),
        ),
        labelText: 'Fecha de nacimiento',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese su fecha de nacimiento';
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
          return 'Debes ser mayor a 18 años para registrarte';
        }

        hasError = false;
        return null;
      },
      onTap: () async {
        pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? currentDate,
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
                headlineMedium: GoogleFonts
                    .quicksand(), // controla: fecha en cabecera, día - mes. mod. 1 y mod. 2
                headlineSmall: GoogleFonts.quicksand(), // no aplica
                titleMedium: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize:
                        18), // controla: título y fecha seleccionada en mod. 2
                titleSmall: GoogleFonts
                    .quicksand(), // Controla: seleccionador de mes y años en mod. 1
                bodyLarge: GoogleFonts.quicksand(), // no aplica
                bodyMedium: GoogleFonts.quicksand(), // no aplica
                bodySmall: GoogleFonts.quicksand(
                    fontSize:
                        14), // controla: numeros de fecha del calendario mod. 1
                labelLarge: GoogleFonts.quicksand(
                    fontWeight: FontWeight
                        .bold), // controla: botones de aceptar y cancelar mod. 1 y mod. 2
                labelSmall: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight
                        .bold), // controla: seleccionar fecha mod. 1 y mod. 2
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFFFF0000),
                    surface: const Color(0xFFFF0000),
                    onPrimary: Colors.white,
                    onSurface: Colors.white,
                  ),
            ),
            child: child!,
          ),
        );
        if (pickedDate != null) {
          lastSelectedDate = pickedDate;
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
}
