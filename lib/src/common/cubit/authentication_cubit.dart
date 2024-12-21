import 'package:bloc/bloc.dart';
import 'package:bookreview/src/common/model/user_model.dart';
import 'package:bookreview/src/common/repository/authentication_repository.dart';
import 'package:bookreview/src/common/repository/user_repository.dart';
import 'package:equatable/equatable.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  AuthenticationCubit(this._authenticationRepository, this._userRepository)
      : super(AuthenticationState());

  void init() {
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      // null 일때는 로그아웃
      emit(state.copyWith(status: AuthenticationStatus.unknown));
    } else {
      // 로그인 상태
      var result = await _userRepository.findUserOne(user.uid!);
      if (result == null) {
        emit(state.copyWith(status: AuthenticationStatus.unknown));
      } else {
        emit(state.copyWith(
          user: result,
          status: AuthenticationStatus.authentication,
        ));
      }
    }
  }
  void googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
  }
  void appleLogin() async {
    await _authenticationRepository.signInWithApple();
  }

  @override
  void onChanged(Change<AuthenticationState> change) {
    super.onChange(change);
    print(change);
  }
}



enum AuthenticationStatus {
  authentication,
  unAuthenticated,
  unknown,
  error,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;

  AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    UserModel? user,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
