import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/data/models/advert.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/logic/cubits/story.dart';
import 'package:inkome_front/logic/states/stories.dart';
import 'package:inkome_front/presentation/widgets/layout.dart';
import 'package:inkome_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:inkome_front/presentation/widgets/utils/pagination_index.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import '../../logic/cubits/adverts.dart';
import '../../logic/states/adverts.dart';
import '../widgets/advert_list.dart';
import '../widgets/utils/snackbar_util.dart';

class IndexPage extends StatelessWidget {
  final String? searchText;

  const IndexPage({Key? key, this.searchText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? token = context.read<AuthenticationCubit>().state.token;
    int itemsPerPage = 10;
    return Layout(
      content: Column(
        children: [
          Expanded(
            child: BlocConsumer<StoryCubit, StoryState>(
              listener: (BuildContext context, StoryState state) {
                if (state.status == StoryStatus.createStoryFailure) {
                  String errorMessage = state.error;
                  SnackBarUtil.showSnackBar(
                    context,
                    backgroundColor: Colors.black,
                    textColor: Colors.black,
                    errorMessage,
                  );
                } else if (state.status == StoryStatus.createStorySuccess) {
                  SnackBarUtil.showSnackBar(
                    context,
                    backgroundColor: Colors.green,
                    textColor: Colors.black,
                    'La historia se creo exitosamente',
                  );
                }
              },
              builder: (BuildContext context, StoryState state) {
                return BlocBuilder<AdvertsCubit, AdvertsState>(
                  builder: (BuildContext context, AdvertsState state) {
                    if (state.status == AdvertsStatus.indexSuccess) {
                      List<Advert> filteredAdverts = state.adverts;
                      int currentFavPageIndex = state.currentPage;
                      int decreasedCurrentPageIndex = currentFavPageIndex - 1;
                      int increasedCurrentPageIndex = currentFavPageIndex + 1;
                      if (filteredAdverts.isEmpty) {
                        return const Center(
                          child: TextView(
                            text: 'No se encontraron anuncios',
                            color: Colors.black,
                          ),
                        );
                      }

                      return ListView(
                        children: [
                          AdvertContentView(adverts: filteredAdverts),
                          const SizedBox(height: 15),
                          PaginationIndex(
                              currentPageIndex: currentFavPageIndex,
                              increasedCurrentPageIndex:
                                  increasedCurrentPageIndex,
                              decreasedCurrentPageIndex:
                                  decreasedCurrentPageIndex,
                              onNextPage: () {
                                if (filteredAdverts.length >= 10) {
                                  context.read<AdvertsCubit>().nextPage(token);
                                }
                              },
                              onPreviousPage: () {
                                if (itemsPerPage > 0) {
                                  context
                                      .read<AdvertsCubit>()
                                      .previousPage(token);
                                }
                              },
                              onFirstPage: () => context
                                  .read<AdvertsCubit>()
                                  .fetchAdverts(token)),
                          const SizedBox(height: 15),
                        ],
                      );
                    } else if (state.status == AdvertsStatus.indexFailure) {
                      return Center(
                        child: TextView(
                          text: state.error,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return const Center(
                        child: CustomIndicatorProgress(),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
