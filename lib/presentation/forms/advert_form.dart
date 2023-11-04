import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/logic/states/adverts.dart';
import 'package:inkome_front/logic/states/authentication.dart';
import 'package:inkome_front/presentation/widgets/utils/ad_tag_editor.dart';
import 'package:inkome_front/presentation/widgets/utils/modal_view.dart';
import 'package:inkome_front/presentation/widgets/utils/custom_button.dart';
import 'package:inkome_front/presentation/widgets/utils/description_form.dart';
import 'package:inkome_front/presentation/widgets/utils/name_form_field.dart';
import 'package:inkome_front/presentation/widgets/utils/phone_form_field.dart';
import 'package:inkome_front/presentation/widgets/utils/pricing_view.dart';
import 'package:inkome_front/presentation/widgets/utils/snackbar_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/advert.dart';
import '../../logic/cubits/adverts.dart';
import '../router/app_router.dart';
import '../widgets/utils/age_form_field.dart';
import '../widgets/utils/multi_file_picker_form_field.dart';

class AdvertForm extends StatefulWidget {
  const AdvertForm({Key? key}) : super(key: key);

  @override
  State<AdvertForm> createState() => _AdvertForm();
}

class _AdvertForm extends State<AdvertForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  int? age;
  String? phoneNumber;
  String? description;
  List<Uint8List>? imageBytes;
  bool initialized = false;
  List<String>? adTags;

  @override
  void initState() {
    AuthenticationState state = context.read<AuthenticationCubit>().state;
    if (state.isLoggedIn()) {
      name = state.user!.name;
      phoneNumber = state.user!.phoneNumber;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return BlocListener<AdvertsCubit, AdvertsState>(
      listenWhen: (prev, current) {
        return prev.status != current.status &&
            (current.status == AdvertsStatus.createFailure ||
                current.status == AdvertsStatus.createSuccess);
      },
      listener: (BuildContext context, AdvertsState state) {
        if (state.status == AdvertsStatus.createFailure) {
          String errorMessage = state.error;
          SnackBarUtil.showSnackBar(
            context,
            backgroundColor: Colors.black,
            textColor: Colors.black,
            errorMessage,
          );
        } else if (state.status == AdvertsStatus.createSuccess) {
          SnackBarUtil.showSnackBar(
            context,
            backgroundColor: Colors.green,
            textColor: Colors.black,
            'El anuncio se creo exitosamente',
          );
          Navigator.pushReplacementNamed(context, Routes.indexPage);
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MultiFilePickerField(
                onChanged: (List<Uint8List>? bytes) {
                  setState(() => imageBytes = bytes);
                },
              ),
              NameFormField(
                onFieldSubmitted: (_) => _submitForm(),
                initialValue: name,
                onChange: (String? value, bool valid) {
                  setState(() => name = valid ? value : null);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AgeFormField(
                ageToShow: age == null ? '18 años' : '$age años',
                initialValue: age,
                onChange: (int value) {
                  setState(() => age = value);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              PhoneFormField(
                onFieldSubmitted: (_) => _submitForm(),
                initialValue: phoneNumber,
                onChange: (String? value, bool valid) {
                  setState(() => phoneNumber = valid ? value : null);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AdTagEditor(
                onFieldSubmitted: (_) => _submitForm(),
                onTagsChanged: (List<String> tags) {
                  setState(() => adTags = tags);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              DescriptionFormField(
                onFieldSubmitted: (_) => _submitForm(),
                maxLines: 5,
                minLines: 1,
                maxLength: 131,
                onChange: (String? value, bool valid) {
                  setState(() => description = valid ? value : null);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 10),
              _buildSubmitButton(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canBuildSubmitButton() {
    return name != null &&
        age != null &&
        phoneNumber != null &&
        description != null &&
        description != '' &&
        imageBytes != null;
  }

  Widget _buildSubmitButton() {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    return CustomButton(
      color: _canBuildSubmitButton() ? null : Colors.grey[300],
      text: t.sendButtonLinkText,
      onPressed: _canBuildSubmitButton() ? _showPricingDialog : null,
    );
  }

  void _showPricingDialog() {
    String? token = context.read<AuthenticationCubit>().state.token;
    if (token == null) {
      throw Exception('Token is missing');
    }
    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext modalContext) => BlocProvider.value(
        value: context.read<AdvertsCubit>(),
        child: ModalView(
          heightFactor: .5,
          widthFactor: .9,
          content: Column(
            children: [
              const Expanded(
                child: PricingView(),
              ),
              _buidFooterModal(modalContext),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buidFooterModal(BuildContext modalContext) {
    return CustomButton(
      onPressed: () {
        _submitForm();
        Navigator.of(modalContext).pop();
      },
      text: 'Submit advert',
    );
  }

  Advert _buildAdvert() {
    return Advert(
      description: description!,
      age: age!,
      name: name!,
      phoneNumber: phoneNumber!,
      images: imageBytes!,
      adTags: adTags,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Advert advert = _buildAdvert();
      String? token = context.read<AuthenticationCubit>().state.token;
      if (token == null) throw Exception('Token is missing');
      context.read<AdvertsCubit>().createAdvert(advert, token);
    }
  }
}
