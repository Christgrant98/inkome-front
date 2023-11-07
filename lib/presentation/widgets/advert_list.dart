import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inkome_front/data/models/advert.dart';
import 'package:inkome_front/data/models/story.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/logic/cubits/navigation.dart';
import 'package:inkome_front/logic/cubits/story.dart';
import 'package:inkome_front/logic/states/stories.dart';
import 'package:inkome_front/presentation/widgets/advert_preview.dart';
import 'package:inkome_front/presentation/widgets/story_view.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class AdvertContentView extends StatelessWidget {
  final List<Advert> adverts;
  int colsPerRow;
  double colsWidth;
  int rowsCount;
  final double spaceBetweenCols;
  final int itemsPerPage;
  BoxConstraints constraints = const BoxConstraints();
  int currentPage;

  AdvertContentView({
    Key? key,
    required this.adverts,
    this.colsPerRow = 0,
    this.colsWidth = 0,
    this.rowsCount = 0,
    this.spaceBetweenCols = 10,
    this.itemsPerPage = 10,
    this.currentPage = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int stateIndex = context.read<NavigationCubit>().getCurrentIndex();
    bool isLogged = context.watch<AuthenticationCubit>().state.isLoggedIn();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        setConstraints(constraints);
        return Column(
          children: [
            if (stateIndex == 0 && isLogged) _buildStories(),
            SizedBox(
              width: constraints.maxWidth,
              child: Table(
                children: generateTableRows(constraints),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStories() {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        if (state.status == StoryStatus.indexSuccess) {
          Map<String, List<Story>> stories = state.stories;
          return StoriesView(
            stories: stories,
          );
        } else if (state.status == StoryStatus.indexFailure) {
          return Center(
            child: TextView(
              text: state.error,
              color: Colors.white,
            ),
          );
        } else {
          return const Center(
            child: TextView(
              text: 'Loading...',
              color: Colors.black,
            ),
          );
        }
      },
    );
  }

  List<TableRow> generateTableRows(BoxConstraints constraints) {
    List<TableRow> tableRows = [];
    colsPerRow = calculateColsPerRow();
    colsWidth = calculateColsWidth();
    rowsCount = calculateRowsCount();

    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    endIndex = endIndex > adverts.length ? adverts.length : endIndex;

    for (int rowIndex = startIndex ~/ colsPerRow;
        rowIndex < (endIndex - 1) ~/ colsPerRow + 1;
        rowIndex++) {
      List<Widget> advertPreviews = generateTableRow(rowIndex);
      while (advertPreviews.length < colsPerRow) {
        advertPreviews.add(Container());
      }

      tableRows.add(TableRow(
        children: advertPreviews,
      ));
    }
    return tableRows;
  }

  List<Widget> generateTableRow(int rowIndex) {
    bool lastRow = rowsCount - 1 == rowIndex;
    int endIndex = lastRow ? adverts.length : colsPerRow * (rowIndex + 1);
    List<Advert> rowAdverts =
        adverts.getRange(rowIndex * colsPerRow, endIndex).toList();
    return List<Widget>.of(
      rowAdverts.map(
        (Advert advert) {
          return AdvertPreview(width: colsWidth, advert: advert);
        },
      ),
    );
  }

  int calculateColsPerRow() {
    if (constraints.maxWidth <= 300) {
      return 1;
    } else if (constraints.maxWidth <= 600) {
      return 2;
    } else if (constraints.maxWidth <= 800) {
      return 3;
    } else if (constraints.maxWidth <= 1000) {
      return 4;
    } else if (constraints.maxWidth <= 1200) {
      return 5;
    } else {
      return 6;
    }
  }

  int calculateRowsCount() {
    if (colsPerRow == 0) return 0;
    return (adverts.length / colsPerRow).ceil();
  }

  double calculateColsWidth() {
    if (colsPerRow == 0) return 0;
    return (constraints.maxWidth - (2 * colsPerRow * spaceBetweenCols)) /
        colsPerRow;
  }

  void setConstraints(BoxConstraints cons) {
    constraints = cons;
  }
}
