import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swc_front/logic/states/current_user.dart';

import '../../data/models/user.dart';
import '../../data/repositories/current_user_repository.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final CurrentUserRepository _repo = CurrentUserRepository();
  CurrentUserCubit() : super(CurrentUserInitial());

  Future<void> fetchCurrentUser() async {
    User user = await _repo.fetch();
    emit(CurrentUserFetchSuccess(user: user));
  }
}
