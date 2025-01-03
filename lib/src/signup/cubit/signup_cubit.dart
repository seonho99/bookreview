import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bookreview/src/common/model/user_model.dart';
import 'package:bookreview/src/common/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class SignupCubit extends Cubit<SignupState> {
  final UserRepository _userRepository;
  SignupCubit(UserModel userModel,this._userRepository) : super(SignupState(userModel: userModel));

  void changeProfileImage(XFile? image) {
    if (image == null) return;
    var file = File(image.path);
    emit(state.copyWith(profileFile: file));
  }

  void changeNickName(String nickname) {
    emit(state.copyWith(nickname: nickname));
  }

  void changeDiscription(String discription) {
    emit(state.copyWith(discription: discription));
  }

  void updateProfileImage(String url) {
    emit(
      state.copyWith(
        status: SignupStatus.loading,
        userModel: state.userModel!.copyWith(profile: url),
      ),
    );
    submit();
  }

  void save() {
    if (state.nickname == null || state.nickname == '') return;
    emit(state.copyWith(status: SignupStatus.loading));
    if (state.profileFile != null) {
      emit(state.copyWith(status: SignupStatus.uploading));
    } else {
      submit();
    }
  }

  void submit() async {
    var joinUserModel = state.userModel!.copyWith(name: state.nickname, discription: state.discription,);
    await _userRepository.joinUser(joinUserModel);
    var result = await _userRepository.joinUser(joinUserModel);
    if(result) {
      emit(state.copyWith(status: SignupStatus.success));
    }else {
      emit(state.copyWith(status: SignupStatus.fail));
    }
  }

  void uploadPercent(String percent) {
    emit(state.copyWith(percent: percent));
  }
}

enum SignupStatus {
  init,
  loading,
  uploading,
  success,
  fail,
}

class SignupState extends Equatable {
  final File? profileFile;
  final String? nickname;
  final String? discription;
  final String? percent;
  final SignupStatus status;
  final UserModel? userModel;

  SignupState({
    this.profileFile,
    this.nickname,
    this.discription,
    this.percent,
    this.status = SignupStatus.init,
    this.userModel,
  });

  SignupState copyWith({
    File? profileFile,
    String? nickname,
    String? discription,
    String? percent,
    SignupStatus? status,
    UserModel? userModel,
  }) {
    return SignupState(
      profileFile: profileFile ?? this.profileFile,
      nickname: nickname ?? this.nickname,
      discription: discription ?? this.discription,
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      percent: percent ?? this.percent,
    );
  }

  @override
  List<Object?> get props =>
      [profileFile, nickname, discription, status, userModel, percent];
}
