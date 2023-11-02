import 'package:flutter/material.dart';

class FavIconContainer extends StatelessWidget {
  final bool selected;

  final double? size;
  final void Function()? onTap;
  final bool isSquare;

  const FavIconContainer({
    super.key,
    this.onTap,
    required this.selected,
    this.size = 30,
    this.isSquare = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 35,
      width: size ?? 35,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),
        borderRadius: BorderRadius.circular(!isSquare ? 20 : 5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Icon(
            shadows: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 2),
                blurRadius: 5.0,
              ),
            ],
            color: selected ? Colors.red : Colors.grey,
            size: selected ? size! * .75 : size! * .7,
            selected ? Icons.favorite : Icons.favorite_border,
          ),
        ),
      ),
    );
  }
}
