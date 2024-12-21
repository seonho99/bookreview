import 'package:bookreview/src/common/init/cubit/init_cubit.dart';
import 'package:bookreview/src/common/init/page/init_page.dart';
import 'package:bookreview/src/splash/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitCubit, bool>
      (builder: (context,state){
      return state ? SplashPage() : InitPage();
    }
    );
  }
}
