import 'package:bookreview/src/common/cubit/authentication_cubit.dart';
import 'package:bookreview/src/common/init/page/init_page.dart';
import 'package:bookreview/src/root/page/root_page.dart';
import 'package:bookreview/src/signup/cubit/signup_cubit.dart';
import 'package:bookreview/src/signup/page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'login/page/login_page.dart';
import 'splash/page/splash_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    // router
    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: context.read<AuthenticationCubit>(),
      redirect: (context, state) {
        var authStatus = context.read<AuthenticationCubit>().state.status;
        switch (authStatus) {
          case AuthenticationStatus.authentication:
            break;
          case AuthenticationStatus.unAuthenticated:
            return 'signup';
          case AuthenticationStatus.unknown:
            return '/login';
          case AuthenticationStatus.init:
            break;
          case AuthenticationStatus.error:
            break;
        }
        return state.path;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => RootPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (context) => SignupCubit(),
            child: SignupPage(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // gorouter navigation 2.0 부터 사용
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: const Color(0xff1C1C1C),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xff1C1C1C),
      ),
      // routerDelegate: router.routerDelegate,
      // routeInformationProvider: router.routeInformationProvider,
      // routeInformationParser: router.routeInformationParser,
    );
  }
}
