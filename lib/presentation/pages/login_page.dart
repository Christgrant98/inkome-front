import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inkome_front/presentation/forms/login_form.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import '../router/app_router.dart';
import '../widgets/layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/logo_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    double screenWidth = MediaQuery.of(context).size.width;
    double desktopScreen = screenWidth * 0.3;
    double mobileScreen = screenWidth * 0.8;
    double desiredWidth = screenWidth > 800 ? desktopScreen : mobileScreen;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Layout(
          content: Center(
            child: SizedBox(
              width: desiredWidth,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _buildtitle('Login'),
                  const SizedBox(height: 15),
                  _buildLogo(),
                  const SizedBox(height: 30),
                  const LoginForm(),
                  _askForSignUpText(context, t),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildtitle(String title) {
    return TextView(
      text: title,
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

  Widget _askForSignUpText(
    BuildContext context,
    AppLocalizations t,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextView(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            text: '¿No tienes una cuenta?'),
        // SizedBox(height: 15),
        TextButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.registrationPage),
          child: const TextView(
            fontSize: 14,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            text: 'Registrate',
          ),
        ),
      ],
    );
  }
}
