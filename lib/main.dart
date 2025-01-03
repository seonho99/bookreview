import 'package:bookreview/firebase_options.dart';
import 'package:bookreview/src/common/cubit/app_data_load_cubit.dart';
import 'package:bookreview/src/common/cubit/authentication_cubit.dart';
import 'package:bookreview/src/common/cubit/upload_cubit.dart';
import 'package:bookreview/src/common/init/cubit/init_cubit.dart';
import 'package:bookreview/src/common/interceptor/custom_interceptor.dart';
import 'package:bookreview/src/common/model/naver_book_search_option.dart';
import 'package:bookreview/src/common/repository/authentication_repository.dart';
import 'package:bookreview/src/common/repository/naver_api_repository.dart';
import 'package:bookreview/src/common/repository/user_repository.dart';
import 'package:bookreview/src/splash/cubit/splash_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Dio dio = Dio(BaseOptions(baseUrl: 'https://openapi.naver.com'));
  dio.interceptors.add(CustomInterceptor());
  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    var storage = FirebaseStorage.instance;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NaverBookRepository(dio),
        ),
        RepositoryProvider(
          create: (context) => AuthenticationRepository(FirebaseAuth.instance),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(db),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UploadCubit(storage)),
          BlocProvider(create: (context) => SplashCubit()),
          BlocProvider(
            create: (context) => InitCubit(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => AppDataLoadCubit(),
            lazy: false,
          ),
          BlocProvider(
              create: (context) => AuthenticationCubit(
                  context.read<AuthenticationRepository>(),
                  context.read<UserRepository>()),
          ),
        ],
        child: App(),
      ),
    );
  }
}
