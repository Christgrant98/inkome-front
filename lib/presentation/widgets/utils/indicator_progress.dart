// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIndicatorProgress extends StatelessWidget {
  const CustomIndicatorProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Color.fromARGB(255, 215, 215, 215),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: Colors.black,
          // radius: 14,
        ),
      ),
    );
  }
}
