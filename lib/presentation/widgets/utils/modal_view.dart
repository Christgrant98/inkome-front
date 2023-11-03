import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModalView extends StatelessWidget {
  final Widget? content;
  final List<BlocProvider> providers;
  final void Function()? onClose;
  final Widget Function()? buildFooter;
  final double? widthFactor;
  final double? heightFactor;
  final double? borderRadius;
  final double? paddingValue;

  const ModalView({
    Key? key,
    this.content,
    this.providers = const [],
    this.onClose,
    this.buildFooter,
    this.widthFactor = 0.9,
    this.heightFactor = 1,
    this.borderRadius = 12,
    this.paddingValue = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception("AppLocalizations not found");
    if (providers.isEmpty) return _buildContent(t);
    return MultiBlocProvider(
      providers: providers,
      child: _buildContent(t),
    );
  }

  Widget _buildContent(AppLocalizations t) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Material(
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: Container(
            padding: EdgeInsets.all(paddingValue!),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius!),
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Column(
              children: [
                if (content != null) Expanded(child: content!),
                if (buildFooter != null) buildFooter!(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
