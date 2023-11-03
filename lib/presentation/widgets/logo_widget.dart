import 'package:flutter/material.dart';

enum Type {
  square,
  rect,
  white,
  short,
}

class Logo extends StatelessWidget {
  final Type type;

  const Logo({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case Type.square:
        return ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset(
              'assets/sqr_logo.png',
            ),
          ),
        );
      case Type.rect:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset(
              'assets/rect_logo.png',
            ),
          ),
        );
      case Type.white:
        return FittedBox(
          fit: BoxFit.cover,
          child: Image.asset(
            'assets/rect_white_logo.png',
          ),
        );
      case Type.short:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset(
              'assets/k_logo.png',
            ),
          ),
        );
    }
  }
}
