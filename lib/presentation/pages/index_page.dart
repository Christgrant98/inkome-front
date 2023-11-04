import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/data/models/advert.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/logic/cubits/story.dart';
import 'package:inkome_front/presentation/widgets/layout.dart';
import 'package:inkome_front/presentation/widgets/story_view.dart';
import 'package:inkome_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:inkome_front/presentation/widgets/utils/pagination_index.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import '../../data/models/story.dart';
import '../../logic/cubits/adverts.dart';
import '../../logic/states/adverts.dart';
import '../../logic/states/stories.dart';
import '../widgets/advert_list.dart';

class IndexPage extends StatelessWidget {
  final String? searchText;

  const IndexPage({Key? key, this.searchText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? token = context.read<AuthenticationCubit>().state.token;
    int currentFavPageIndex = context.watch<AdvertsCubit>().state.currentPage;
    int decreasedCurrentPageIndex = currentFavPageIndex - 1;
    int increasedCurrentPageIndex = currentFavPageIndex + 1;
    int itemsPerPage = 10;

    return Layout(
      content: Column(
        children: [
          BlocBuilder<StoryCubit, StoryState>(
            builder: (context, state) {
              if (state.status == StoryStatus.indexSuccess) {
                Map<String, List<Story>> stories = state.stories;
                if (stories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: TextView(
                        text: 'No se encontraron historias o promociones',
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return StoriesView(
                  stories: state.stories,
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
          ),
          Expanded(
            child: BlocBuilder<AdvertsCubit, AdvertsState>(
              builder: (BuildContext context, AdvertsState state) {
                if (state.status == AdvertsStatus.indexSuccess) {
                  List<Advert> filteredAdverts = state.adverts;

                  if (searchText != null && searchText!.length >= 3) {
                    filteredAdverts = state.adverts
                        .where((advert) => advert.name
                            .toLowerCase()
                            .contains(searchText!.toLowerCase()))
                        .toList();
                  }

                  if (filteredAdverts.isEmpty) {
                    return const Center(
                      child: TextView(
                        text: 'No se encontraron anuncios',
                        color: Colors.white,
                      ),
                    );
                  }

                  return ListView(
                    children: [
                      AdvertList(adverts: filteredAdverts),
                      const SizedBox(height: 15),
                      PaginationIndex(
                        currentPageIndex: currentFavPageIndex,
                        increasedCurrentPageIndex: increasedCurrentPageIndex,
                        decreasedCurrentPageIndex: decreasedCurrentPageIndex,
                        onNextPage: () {
                          if (filteredAdverts.length >= 10) {
                            context.read<AdvertsCubit>().nextPage(token);
                          }
                        },
                        onPreviousPage: () {
                          if (itemsPerPage > 0) {
                            context.read<AdvertsCubit>().previousPage(token);
                          }
                        },
                        onFirstPage: () =>
                            context.read<AdvertsCubit>().fetchAdverts(token),
                      ),
                      const SizedBox(height: 15)
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
                  return const Center(child: CustomIndicatorProgress());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
