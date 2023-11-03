import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/layout.dart';
import 'package:inkome_front/presentation/forms/registration_form.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

import '../widgets/logo_widget.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desktopScreen = screenWidth * 0.3;
    double mobileScreen = screenWidth * 0.8;
    double desiredWidth = screenWidth > 800 ? desktopScreen : mobileScreen;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Layout(
        content: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: desiredWidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _buildtitle('Sign Up'),
                  const SizedBox(height: 15),
                  _buildLogo(),
                  const SizedBox(height: 15),
                  const RegistrationForm(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildtitle(String title) {
    return const TextView(
      text: 'Sign Up',
      fontSize: 30,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildLogo() {
    return const SizedBox(
      height: 65,
      width: 65,
      child: Logo(
        type: Type.short,
      ),
    );
  }
}
