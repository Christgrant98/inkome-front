import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/data/models/story.dart';
import 'package:inkome_front/data/models/user.dart';
import 'package:inkome_front/data/repositories/story_repository.dart';
import 'package:inkome_front/logic/states/stories.dart';

class StoryCubit extends Cubit<StoryState> {
  final StoryRepository _storyRepository = StoryRepository();

  StoryCubit() : super(StoryState.initial());

  Future<void> createStory(Story story, String? token) async {
    try {
      emit(
        state.copyWith(status: StoryStatus.createStoryLoading),
      );
      Story createdStory = await _storyRepository.createStory(story, token!);
      state.stories[state.userId]!.add(createdStory);
      emit(state.copyWith(
        status: StoryStatus.createStorySuccess,
        stories: state.stories,
      ));
    } catch (error) {
      emit(
        state.copyWith(
          status: StoryStatus.createStoryFailure,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> fetchUserStories(String? token) async {
    emit(
      state.copyWith(status: StoryStatus.fetchUserStoryLoading),
    );
    if (state.stories[state.userId]!.isEmpty) {
      List<Story> stories =
          await _storyRepository.fetchStories(token, state.userId);
      state.stories[state.userId] = stories;
    }
    try {
      emit(
        state.copyWith(
            status: StoryStatus.fetchUserStorySuccess, stories: state.stories),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: StoryStatus.fetchUserStoryFailure,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> fetchAllStoriesUsers(String? token) async {
    emit(state.copyWith(status: StoryStatus.indexAllLoading));
    List<User> storiesUsers = await _storyRepository.fetchStoriesUsers(token);
    Map<String, List<Story>>? stories = {};
    for (var user in storiesUsers) {
      String storyUserId = user.id!;
      stories[storyUserId] = [];
    }
    try {
      emit(
        state.copyWith(
          status: StoryStatus.indexAllSuccess,
          stories: stories,
          storiesUsers: storiesUsers,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: StoryStatus.indexAllFailure,
          error: error.toString(),
        ),
      );
    }
  }
}
