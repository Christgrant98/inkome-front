import 'package:flutter/material.dart';

class CustomBottomModal extends StatelessWidget {
  final double height;
  final Widget content;
  const CustomBottomModal({
    super.key,
    required this.content,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;
    double behindContainerWidth = screenWidth * .95;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.5),
              topRight: Radius.circular(12.5),
            ),
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          width:
              isLargeScreen ? behindContainerWidth * .35 : behindContainerWidth,
          height: 10,
        ),
        Container(
          height: height,
          width: isLargeScreen ? screenWidth * .35 : screenWidth,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.5),
              topRight: Radius.circular(12.5),
            ),
            color: Colors.white,
          ),
          child: content,
        )
      ],
    );
  }
}
