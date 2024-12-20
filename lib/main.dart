import 'package:bookreview/firebase_options.dart';
import 'package:bookreview/src/common/interceptor/custom_interceptor.dart';
import 'package:bookreview/src/common/model/naver_book_search_option.dart';
import 'package:bookreview/src/common/repository/naver_api_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NaverBookRepository(dio),
        ),
      ],
      child: Builder(
        builder: (context) => FutureBuilder(
          future: context.read<NaverBookRepository>().searchBooks(
                NaverBookSearchOption.init(
                  query: '플러터',
                ),
              ),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return MaterialApp(home: Center(child: Text('${snapshot.data?.items?.length??0 }'),));
            }
            return Container();
          },
        ),
      ),
      // MultiBlocProvider(
      //   providers: [
      //   ],
      //   child: App(),
      // ),
    );
  }
}
