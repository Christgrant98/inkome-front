import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class StoryBubble extends StatelessWidget {
  final Uint8List? profilePicture;
  final String? username;
  final String? userId;
  const StoryBubble({
    super.key,
    required this.profilePicture,
    required this.username,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    String firstName = username!.split(' ')[0];

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 38.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(
                profilePicture!,
              ),
            ),
          ),
          TextView(
            text: firstName,
            fontSize: 12,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
