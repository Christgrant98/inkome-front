import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkome_front/presentation/widgets/utils/custom_bottom_modal.dart';

import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class UploadStoryButton extends StatefulWidget {
  final void Function(Uint8List) onChanged;
  const UploadStoryButton({
    super.key,
    required this.onChanged,
  });

  @override
  State<UploadStoryButton> createState() => _UploadStoryButtonState();
}

class _UploadStoryButtonState extends State<UploadStoryButton> {
  final FilePicker _filePicker = FilePicker.platform;
  FilePickerResult? result;
  bool isLoading = false;
  Uint8List? _pickedFile;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
              onTap: () => showModalBottomSheet(
                    barrierColor: Colors.black87,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: _buildBottomModal(),
                    ),
                  ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.black, Color.fromARGB(255, 80, 80, 80)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const CircleAvatar(
                  minRadius: 25,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              )),
        ),
        const SizedBox(height: 5),
        const TextView(
          text: 'Your Story',
          fontSize: 11,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildBottomModal() {
    return CustomBottomModal(
      height: 250,
      content: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            const Center(
              child: TextView(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                text: 'Select an option',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            _buildMenuOption(
              title: 'Open camera',
              onTap: () => getImageAndPickFile(),
              icon: Icons.camera,
            ),
            const SizedBox(height: 5),
            _buildMenuOption(
              title: 'Upload image from device',
              onTap: () => pickFile(),
              icon: Icons.cloud_upload,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required String title,
    required void Function() onTap,
    required IconData icon,
  }) {
    return Card(
      elevation: 1.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: const Color.fromARGB(255, 230, 230, 230),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: TextView(
          text: title,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }

  void getImageAndPickFile() async {
    setState(() {
      isLoading = true;
    });

    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      _pickedFile = Uint8List.fromList(fileBytes);
      widget.onChanged(_pickedFile!);
    }

    setState(() {
      isLoading = false;
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
      );

      if (result != null) {
        _pickedFile = result!.files.single.bytes;
        widget.onChanged(_pickedFile!);
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      TextView(text: error.toString());
    }
  }
}
