import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/presentation/router/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InkomeApp extends StatelessWidget {
  final AuthenticationCubit authenticationCubit = AuthenticationCubit();
  InkomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter =
        AppRouter(authenticationCubit: authenticationCubit);
    return BlocProvider.value(
      value: authenticationCubit,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFFF0000),
          ),
          primaryColor: const Color(0xFFFF0000),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
