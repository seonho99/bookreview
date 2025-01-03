import 'dart:io';

import 'package:bookreview/src/common/components/app_font.dart';
import 'package:bookreview/src/common/components/btn.dart';
import 'package:bookreview/src/common/cubit/authentication_cubit.dart';
import 'package:bookreview/src/common/cubit/upload_cubit.dart';
import 'package:bookreview/src/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/components/loading.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  Widget _signupView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset('assets/svg/icons/icons_close.svg'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _UserProfileImageFiled(),
            SizedBox(height: 50),
            _NicknameFiled(),
            SizedBox(height: 30),
            _DiscriptionFiled(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: Btn(
                onTap: context.read<SignupCubit>().save,
                text: '가입',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Btn(
                backgroundColor: Color(0xff212121),
                onTap: () {},
                text: '취소',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignupCubit, SignupState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case SignupStatus.init:
                break;
              case SignupStatus.loading:
                break;
              case SignupStatus.uploading:
                context.read<UploadCubit>().uploadUserProFile(
                    state.profileFile!, state.userModel!.uid!);
                break;
              case SignupStatus.success:
                context.read<AuthenticationCubit>().reloadAuth();
                break;
              case SignupStatus.fail:
                break;
            }
          },
        ),
        BlocListener<UploadCubit, UploadState>(
          listener: (context, state) {
            switch (state.status) {
              case UploadStatus.init:
                break;
              case UploadStatus.uploading:
                state.percent!.toStringAsFixed(2);
                context
                    .read<SignupCubit>()
                    .uploadPercent(state.percent!.toStringAsFixed(2));
                break;
              case UploadStatus.success:
                context.read<SignupCubit>().updateProfileImage(state.url!);
                break;
              case UploadStatus.fail:
                break;
            }
          },
        ),
      ],
      child: Stack(
        children: [
          _signupView(context),
          BlocBuilder<SignupCubit, SignupState>(
            buildWhen: (previous, current) => previous.percent != current.percent || previous.status != current.status,
            builder: (context, state) {
              if(state.percent != null && state.status == SignupStatus.uploading){
                return Loading(loadingMessage: '${state.percent}%');
              } else{
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _UserProfileImageFiled extends StatelessWidget {
  _UserProfileImageFiled({super.key});

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var profileFile =
        context.select<SignupCubit, File?>((cubit) => cubit.state.profileFile);
    return Center(
      child: GestureDetector(
        onTap: () async {
          var image = await _picker.pickImage(source: ImageSource.gallery);
          context.read<SignupCubit>().changeProfileImage(image);
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: profileFile == null
              ? Image.asset('assets/images/default_avatar.png').image
              : Image.file(profileFile).image,
          radius: 50,
        ),
      ),
    );
  }
}

class _NicknameFiled extends StatelessWidget {
  const _NicknameFiled({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFont(
          '닉네임',
          size: 16,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          onChanged: context.read<SignupCubit>().changeNickName,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xff232323),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscriptionFiled extends StatelessWidget {
  const _DiscriptionFiled({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFont(
          '한줄 소개',
          size: 16,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          onChanged: context.read<SignupCubit>().changeDiscription,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12),
          maxLength: 50,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xff232323),
            counterStyle: TextStyle(color: Colors.white, fontSize: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
