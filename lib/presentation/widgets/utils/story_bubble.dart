import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class StoryBubble extends StatelessWidget {
  final Uint8List? profilePicture;
  final String username;
  final String userId;
  const StoryBubble({
    super.key,
    required this.profilePicture,
    required this.username,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    String firstName = username.split(' ')[0];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CircleAvatar(
            minRadius: 25,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 33.5,
              backgroundImage: MemoryImage(profilePicture!),
            ),
          ),
        ),
        const SizedBox(height: 5),
        TextView(
          text: firstName,
          fontSize: 12,
          color: Colors.black,
        )
      ],
    );
  }
}
