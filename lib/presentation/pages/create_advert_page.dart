import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/layout.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import '../forms/advert_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAdvertPage extends StatelessWidget {
  const CreateAdvertPage({super.key});

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
              child: ListView(
                children: [
                  SizedBox(height: isLargeScreen ? 50 : 10),
                  const TextView(
                      text: 'New Advert',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.black),
                  const AdvertForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
