import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/presentation/router/app_router.dart';
import 'package:inkome_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

import '../../logic/cubits/story.dart';
import '../../logic/states/stories.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StoryState storyState = context.read<StoryCubit>().state;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: BlocBuilder<StoryCubit, StoryState>(
            builder: (BuildContext context, StoryState state) {
              if (state.status == StoryStatus.fetchUserStorySuccess) {
                return _buildStoryView(storyState);
              } else if (state.status == StoryStatus.fetchUserStoryFailure) {
                return const Center(
                  child: TextView(
                    text: 'Something went wrong',
                    color: Colors.red,
                  ),
                );
              } else {
                return const Center(
                  child: CustomIndicatorProgress(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStoryView(StoryState state) {
    return Stack(
      children: [
        Center(
          child: _builStoryPicture(state: state),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBttn(
                Icons.arrow_back_ios_rounded,
                onPressed: () {
                  if (_pageController.page! <
                      state.stories[state.userId]!.length - 1) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
              _buildBttn(
                Icons.arrow_forward_ios_rounded,
                onPressed: () {
                  if (_pageController.page! <
                      state.stories[state.userId]!.length - 1) {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.easeInOut);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBttn(
    IconData icon, {
    required void Function()? onPressed,
  }) {
    return CircleAvatar(
      backgroundColor: const Color.fromARGB(173, 92, 92, 92),
      radius: 35,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          color: Colors.white,
          icon,
          size: 25,
        ),
      ),
    );
  }

  Widget _builStoryPicture({
    required StoryState state,
  }) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemCount: state.stories[state.userId]!.length,
              itemBuilder: (BuildContext context, int index) {
                final story = state.stories[state.userId]![index];
                return Image.memory(
                  story.image!,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: state.stories[state.userId]!.isNotEmpty
              ? Container(
                  height: 50,
                  color: const Color.fromARGB(154, 0, 0, 0),
                  child: DotsIndicator(
                    position: _currentPageIndex,
                    dotsCount: state.stories[state.userId]!.length,
                    decorator: DotsDecorator(
                      activeColor: Colors.white,
                      activeSize: const Size(14, 14),
                      color: Colors.grey[400]!,
                      size: const Size(12, 12),
                    ),
                  ),
                )
              : Container(),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Routes.indexPage),
            icon: const Icon(
              CupertinoIcons.xmark_square_fill,
              size: 50,
              shadows: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 2), blurRadius: 5.0)
              ],
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
