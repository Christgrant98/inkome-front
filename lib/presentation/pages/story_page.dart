import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/data/models/story.dart';
import 'package:inkome_front/presentation/router/app_router.dart';
import 'package:inkome_front/presentation/widgets/utils/base_modal.dart';

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
    StoryState storyState = context.watch<StoryCubit>().state;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: _buildStoryView(storyState),
        ),
      ),
    );
  }

  Widget _buildStoryView(StoryState state) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          scrollDirection: Axis.horizontal,
          itemCount: state.stories[state.userId]!.length,
          itemBuilder: (context, index) {
            final story = state.stories[state.userId]![index];
            return BaseModal(
              children: [
                _builStoryPicture(context, story: story),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _builStoryPicture(
    BuildContext context, {
    required Story story,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: AspectRatio(
        aspectRatio: 9 / 15,
        child: Image.memory(
          story.image!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
