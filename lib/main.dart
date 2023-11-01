// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blissbite_front/logic/cubits/authentication_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'presentation/router/app_router.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(SwcApp());
}

class SwcApp extends StatelessWidget {
  final AuthenticationCubit authenticationCubit = AuthenticationCubit();
  SwcApp({super.key});

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
