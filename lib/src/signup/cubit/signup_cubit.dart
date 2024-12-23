import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

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

  void save() {
    if (state.nickname == null || state.nickname = '') return;
    if (state.profileFile != null) {

    } else {

    }
  }
}

class SignupState extends Equatable {
  final File? profileFile;
  final String? nickname;
  final String? discription;

  SignupState({this.profileFile, this.nickname, this.discription});

  SignupState copyWith(
      {File? profileFile, String? nickname, String? discription}) {
    return SignupState(
      profileFile: profileFile ?? this.profileFile,
      nickname: nickname ?? this.nickname,
      discription: discription ?? this.discription,
    );
  }

  @override
  List<Object?> get props => [profileFile, nickname, discription];
}
