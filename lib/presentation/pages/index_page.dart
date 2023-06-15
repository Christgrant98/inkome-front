import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swc_front/logic/cubits/authentication_cubit.dart';
import 'package:swc_front/presentation/widgets/layout.dart';
import 'package:swc_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:swc_front/presentation/widgets/utils/pagination_index.dart';
import 'package:swc_front/presentation/widgets/utils/search_bar.dart';
import 'package:swc_front/presentation/widgets/utils/story_bubble.dart';
import 'package:swc_front/presentation/widgets/utils/text_view.dart';
import '../../logic/cubits/adverts.dart';
import '../../logic/states/adverts.dart';
import '../widgets/advert_list.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? token = context.read<AuthenticationCubit>().state.token;
    int currentFavPageIndex = context.watch<AdvertsCubit>().state.currentPage;
    int decreasedCurrentPageIndex = currentFavPageIndex - 1;
    int increasedCurrentPageIndex = currentFavPageIndex + 1;
    int itemsPerPage = 10;
    int currentPage = 0;

    return Layout(
      content: BlocBuilder<AdvertsCubit, AdvertsState>(
        builder: (BuildContext context, AdvertsState state) {
          if (state.status == AdvertsStatus.indexSuccess) {
            return Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 80,
                      child: SearchTextFieldExample(),
                    ),
                    Expanded(
                      flex: 30,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset('assets/Logo rojo.svg'),
                      ),
                    )
                  ],
                ),
                // const SearchAppBar(),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: 20,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return StoryBubble();
                      }),
                ),

                // SPACE DESIGNED TO ADVERTS POST AS LISTVIEW
                Expanded(
                  child: ListView(
                    children: [
                      AdverList(adverts: state.adverts),
                      const SizedBox(height: 15),
                      PaginationIndex(
                        currentPageIndex: currentFavPageIndex,
                        increasedCurrentPageIndex: increasedCurrentPageIndex,
                        decreasedCurrentPageIndex: decreasedCurrentPageIndex,
                        onNextPage: () {
                          if (state.adverts.length >= 10) {
                            currentPage++;
                            context.read<AdvertsCubit>().nextPage(token);
                          }
                        },
                        onPreviousPage: () {
                          if (itemsPerPage > 0) {
                            currentPage--;
                            context.read<AdvertsCubit>().previousPage(token);
                          }
                        },
                      ),
                      const SizedBox(height: 15)
                    ],
                  ),
                ),
              ],
            );
          } else if (state.status == AdvertsStatus.indexFailure) {
            return TextView(text: state.error, color: const Color(0xFFFF0000));
          } else {
            return const Center(child: CustomIndicatorProgress());
          }
        },
      ),
    );
  }
}
