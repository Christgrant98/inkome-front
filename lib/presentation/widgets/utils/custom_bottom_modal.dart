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
          width: MediaQuery.of(context).size.width * .95,
          height: 10,
        ),
        Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.5),
                topRight: Radius.circular(12.5)),
            color: Colors.white,
          ),
          child: content,
        )
      ],
    );
  }
}
