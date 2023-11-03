import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/presentation/router/app_router.dart';
import 'package:inkome_front/presentation/widgets/utils/alert_dialog_custom.dart';
import 'package:inkome_front/presentation/widgets/utils/custom_button.dart';
import 'package:inkome_front/presentation/widgets/utils/date_picker.dart';
import 'package:inkome_front/presentation/widgets/utils/email_form_field.dart';
import 'package:inkome_front/presentation/widgets/utils/image_picker_button.dart';
import 'package:inkome_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:inkome_front/presentation/widgets/utils/name_form_field.dart';
import 'package:inkome_front/presentation/widgets/utils/phone_form_field.dart';
import 'package:inkome_front/presentation/widgets/utils/snackbar_util.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import '../../data/models/user.dart';
import '../../logic/cubits/authentication_cubit.dart';
import '../../logic/states/authentication.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/utils/custom_bottom_modal.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileForm();
}

class _ProfileForm extends State<ProfileForm> {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  DateTime? birthdate;
  Uint8List? image;

  @override
  void initState() {
    AuthenticationState state = context.read<AuthenticationCubit>().state;
    if (state.isLoggedIn()) {
      id = state.user?.id;
      name = state.user?.name;
      phoneNumber = state.user?.phoneNumber;
      email = state.user?.email;
      birthdate = state.user?.birthdate;
      image = state.user?.image;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    bool isLogged = context.watch<AuthenticationCubit>().isLogged();
    User? currentUser = context.watch<AuthenticationCubit>().state.user;
    Uint8List? userImage = currentUser?.image;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        if (state.authenticationStatus == AuthenticationStatus.updateSuccess) {
          Navigator.pushReplacementNamed(context, Routes.indexPage);
        } else if (state.authenticationStatus ==
            AuthenticationStatus.updateFailure) {
          String errorMessage =
              state.error ?? 'Ocurrió un error al actualizar el usuario';
          SnackBarUtil.showSnackBar(
            context,
            icon: const Icon(Icons.error_outline),
            backgroundColor: Colors.black,
            errorMessage,
          );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextView(
                text: t.myProfileTitleLinkText,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.black),
            const SizedBox(
              height: 25,
            ),
            if (isLogged)
              TextView(
                text: '$name',
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            const SizedBox(
              height: 25,
            ),
            ImagePickerButton(
              initialValue: image ?? userImage,
              onChanged: (Uint8List? bytes) {
                setState(() => image = bytes);
              },
            ),
            const SizedBox(
              height: 25,
            ),
            NameFormField(
              initialValue: name,
              onChange: (String? value, bool valid) {
                setState(() => name = valid ? value : null);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            DatePickerField(
              initialValue: birthdate,
              onChange: (int value, DateTime selectedBirthdate) {
                setState(() => birthdate = selectedBirthdate);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            PhoneFormField(
              initialValue: phoneNumber,
              onChange: (String? value, bool valid) {
                setState(() => phoneNumber = valid ? value : null);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            EmailFormField(
              initialValue: email,
              onChange: (String? value, bool valid) {
                setState(() => email = valid ? value : null);
              },
            ),
            const SizedBox(
              height: 35,
            ),
            // Spacer(),
            // if (_canShowSubmitButton())
            _buildSubmitButton(),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: _buildLogoutButton(),
            ),
          ],
        ),
      ),
    );
  }

  // bool _canShowSubmitButton() {
  //   return name != null && age != null && phoneNumber != null;
  // }

  Widget _buildSubmitButton() {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');

    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
      if (state.authenticationStatus == AuthenticationStatus.loading) {
        return const CustomIndicatorProgress();
      } else {
        return CustomButton(
          text: t.editButtonLinkText,
          onPressed: () {
            User user = _buildUser();
            BlocProvider.of<AuthenticationCubit>(context).update(user);
          },
        );
      }
    });
  }

  User _buildUser() {
    return User(
      id: id,
      name: name!,
      phoneNumber: phoneNumber!,
      email: email!,
      birthdate: birthdate!,
      image: image!,
    );
  }

  Widget _buildLogoutButton() {
    return CustomButton(
      buttonTextColor: Colors.black,
      isAppColor: false,
      text: 'Logout',
      onPressed: () {
        _buildConfirmationLogoutModal();
      },
    );
  }

  Future<dynamic> _buildConfirmationLogoutModal() {
    return showModalBottomSheet(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: CustomBottomModal(
            height: 200,
            content: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                const TextView(
                  text: 'Are you sure to Log out?',
                  color: Colors.red,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      CustomButton(
                        buttonTextColor: Colors.black,
                        isAppColor: false,
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        color: Colors.red,
                        text: 'Logout',
                        onPressed: () {
                          BlocProvider.of<AuthenticationCubit>(context)
                              .logout();
                          Navigator.pushReplacementNamed(
                              context, Routes.indexPage);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
