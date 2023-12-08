import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inkome_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultiFilePickerField extends StatefulWidget {
  final void Function(List<Uint8List>) onChanged;

  const MultiFilePickerField({Key? key, required this.onChanged})
      : super(key: key);

  @override
  State<MultiFilePickerField> createState() => _MultiFilePickerField();
}

class _MultiFilePickerField extends State<MultiFilePickerField> {
  final FilePicker _filePicker = FilePicker.platform;
  FilePickerResult? result;
  bool isLoading = false;
  int _currentImageIndex = 0;
  final List<Uint8List> _pickedFiles = [];

  @override
  void dispose() {
    if (!kIsWeb) _filePicker.clearTemporaryFiles();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');
    if (isLoading) {
      return const Center(
        child: CustomIndicatorProgress(),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        if (_pickedFiles.isNotEmpty)
          const TextView(
            text: 'Select photos to upload the advert',
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        const SizedBox(height: 15),
        Stack(
          children: [
            Column(
              children: [
                if (_pickedFiles.isEmpty)
                  Column(children: [
                    _buildSelectFileBtn(),
                    const SizedBox(height: 10),
                    const TextView(
                      text: 'Select an image to show',
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    )
                  ]),
                if (_pickedFiles.isNotEmpty) _buildCarouselSlider(context),
                _pickedFiles.isNotEmpty
                    ? DotsIndicator(
                        dotsCount: _pickedFiles.length,
                        position: _currentImageIndex,
                        decorator: DotsDecorator(
                          activeColor: Colors.black,
                          activeSize: const Size(7, 7),
                          color: Colors.grey[600]!,
                          size: const Size(4, 4),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 15,
                ),
                if (_pickedFiles.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildClearFileBtn(),
                      const SizedBox(width: 15),
                      if (_pickedFiles.length > 1) _buildRemoveFileBtn(),
                      const SizedBox(width: 15),
                      _buildSelectFileBtn(),
                    ],
                  ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarouselSlider(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          // animateToClosest: true,
          enableInfiniteScroll: (_pickedFiles.length) >= 3 ? true : false,
          autoPlay: false,
          enlargeCenterPage: true,
          aspectRatio: 1.4,
          viewportFraction: 0.5,
          onPageChanged: (index, _) {
            setState(() {
              _currentImageIndex = index;
            });
          }),
      items: _pickedFiles.map((image) {
        final int index = _pickedFiles.indexOf(image);
        return ClipRRect(
          borderRadius: BorderRadius.circular(18.5),
          child: index == 0
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(18.5),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        image,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.black.withOpacity(.65),
                          height: MediaQuery.of(context).size.height * .05,
                          child: const Center(
                              child: TextView(
                            text: 'Advert cover',
                            color: Colors.white,
                          )),
                        ),
                      ),
                      const Positioned(
                          top: 5,
                          right: 5,
                          child: Icon(
                            shadows: [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 2),
                                  blurRadius: 5.0)
                            ],
                            Icons.loyalty_rounded,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
                  ),
                )
              : Image.memory(
                  image,
                  fit: BoxFit.cover,
                ),
        );
      }).toList(),
    );
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
        _pickedFiles.add(bytes);
        widget.onChanged(_pickedFiles);
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      TextView(text: error.toString());
    }
  }

  void cleanFiles() {
    setState(() {
      _pickedFiles.clear();
    });
  }

  void _updateCurrentImageIndex() {
    if (_currentImageIndex >= _pickedFiles.length) {
      _currentImageIndex = _pickedFiles.length - 1;
    }
  }

  void _removeCurrentImage() {
    setState(() {
      _pickedFiles.removeAt(_currentImageIndex);
      _updateCurrentImageIndex();
    });
  }

  Widget _buildSelectFileBtn() {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        width: 45,
        height: 45,
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
        child: Icon(
          _pickedFiles.isEmpty
              ? CupertinoIcons.camera_fill
              : CupertinoIcons.add,
          color: Colors.white,
          size: 30,
          shadows: const [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 2), blurRadius: 5.0)
          ],
        ),
      ),
    );
  }

  Widget _buildClearFileBtn() {
    return GestureDetector(
      onTap: cleanFiles,
      child: Container(
        width: 45,
        height: 45,
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
          CupertinoIcons.delete,
          color: Colors.white,
          size: 30,
          shadows: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 2), blurRadius: 5.0)
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveFileBtn() {
    return GestureDetector(
      onTap: _removeCurrentImage,
      child: Container(
        width: 45,
        height: 45,
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
          CupertinoIcons.clear,
          size: 30,
          color: Colors.white,
          shadows: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 2), blurRadius: 5.0)
          ],
        ),
      ),
    );
  }
}
