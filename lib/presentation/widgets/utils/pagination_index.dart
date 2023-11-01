import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blissbite_front/logic/cubits/adverts.dart';
import 'package:blissbite_front/presentation/widgets/utils/text_view.dart';

class PaginationIndex extends StatelessWidget {
  final int currentPageIndex;
  final int decreasedCurrentPageIndex;
  final int increasedCurrentPageIndex;
  final Function() onPreviousPage;
  final Function() onNextPage;
  final Function() onFirstPage;

  const PaginationIndex({
    super.key,
    required this.currentPageIndex,
    required this.decreasedCurrentPageIndex,
    required this.increasedCurrentPageIndex,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onFirstPage,
  });

  @override
  Widget build(BuildContext context) {
    int? advertCount = context.read<AdvertsCubit>().state.adverts.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentPageIndex > 1)
          paginationButton(
            onTap: onFirstPage,
            child: const Icon(
              size: 20,
              color: Colors.black,
              Icons.skip_previous_rounded,
            ),
          ),
        paginationButton(
          border: Border.all(color: Colors.black, width: 1),
          onTap: onPreviousPage,
          child: const Icon(
            size: 20,
            color: Colors.black,
            Icons.arrow_back_ios_rounded,
          ),
        ),
        if (decreasedCurrentPageIndex > 0)
          paginationButton(
            onTap: onPreviousPage,
            child: Center(
              child: TextView(
                  fontWeight: FontWeight.bold,
                  text: '$decreasedCurrentPageIndex',
                  color: Colors.black),
            ),
          ),
        paginationButton(
          border: Border.all(color: Colors.orange, width: 2.5),
          child: Center(
            child: TextView(
                fontWeight: FontWeight.bold,
                text: '$currentPageIndex',
                color: Colors.black),
          ),
          onTap: () {},
        ),
        if (advertCount >= 10)
          paginationButton(
            onTap: onNextPage,
            child: Center(
              child: TextView(
                  fontWeight: FontWeight.bold,
                  text: '$increasedCurrentPageIndex',
                  color: Colors.black),
            ),
          ),
        paginationButton(
          border: Border.all(color: Colors.black, width: 1),
          onTap: onNextPage,
          child: const Icon(
            size: 20,
            color: Colors.black,
            Icons.arrow_forward_ios_rounded,
          ),
        ),
      ],
    );
  }

  Widget paginationButton(
          {required Widget child, Function()? onTap, BoxBorder? border}) =>
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: border),
            height: 40,
            width: 40,
            child: child,
          ),
        ),
      );
}
