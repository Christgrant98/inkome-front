import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class ImagePickerButton extends StatefulWidget {
  final Function(Uint8List) onChanged;
  final Uint8List? initialValue;

  const ImagePickerButton({
    Key? key,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  final FilePicker _filePicker = FilePicker.platform;
  FilePickerResult? result;
  bool isLoading = false;
  Uint8List? _pickedFile;

  @override
  void initState() {
    super.initState();
    _pickedFile = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child: Stack(
            children: [
              _buildProfilePicture(context),
              if (isLoading)
                const Positioned.fill(
                  child: Center(
                    child: CustomIndicatorProgress(),
                  ),
                ),
            ],
          ),
        ),
        if (!isLoading)
          Positioned(
            bottom: 1,
            right: 1,
            child: GestureDetector(
              onTap: pickFile,
              child: _buildUploadImageButton(),
            ),
          ),
      ],
    );
  }

  SizedBox _buildProfilePicture(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: (_pickedFile != null)
          ? InkWell(
              onTap: () => _showProfilePicturePreview(context),
              child: Image.memory(
                _pickedFile!,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset('user_default1.jpg'),
    );
  }

  Widget _buildUploadImageButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 4),
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3,
          ),
        ],
      ),
      child: const Icon(
        CupertinoIcons.switch_camera,
        color: Colors.white,
        shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 5.0)
        ],
      ),
    );
  }

  Future<dynamic> _showProfilePicturePreview(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                backgroundColor: Colors.black.withOpacity(0.25),
                title: const TextView(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    text: 'Profile Picture'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                content: Image.memory(
                  _pickedFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await _filePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      Uint8List? bytes = result!.files.single.bytes;

      if (bytes != null) {
        _pickedFile = bytes;
        widget.onChanged(_pickedFile!);
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }
}
