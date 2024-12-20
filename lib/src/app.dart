import 'package:bookreview/src/common/init/page/init_page.dart';
import 'package:bookreview/src/root/page/root_page.dart';
import 'package:flutter/material.dart';
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
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => RootPage(),
        ),
        GoRoute(path: '/login', builder: (context, state) => LoginPage(),
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
