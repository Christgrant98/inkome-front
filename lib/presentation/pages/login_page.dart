import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swc_front/presentation/forms/login_form.dart';
import 'package:swc_front/presentation/widgets/utils/text_view.dart';
import '../router/app_router.dart';
import '../widgets/layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Layout(
          content: Center(
        child: SizedBox(
            width: constraints.maxWidth * 0.8,
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 165,
                  width: 165,
                  child: SvgPicture.asset(
                    'assets/Logo blanco.svg',
                  ),
                ),
                // const SizedBox(height: 15),
                const LoginForm(),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.registrationPage);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextView(
                      text: t.registrationLinkText,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
      ));
    });
  }
}


//  content: Center(child: SizedBox(width: contrains.maxwidht, child: LoginForm())),
