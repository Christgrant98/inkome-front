import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/layout.dart';
import '../forms/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desktopScreen = screenWidth * 0.3;
    double mobileScreen = screenWidth * 0.8;
    bool isLargeScreen = screenWidth > 800;
    double desiredWidth = isLargeScreen ? desktopScreen : mobileScreen;
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Layout(
        content: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: desiredWidth,
            child: const ProfileForm(),
          ),
        ),
      );
    });
  }
}
