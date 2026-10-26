import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../app_import.dart';
import '../page/login/login_page.dart';
import '../page/home/home_page.dart';

class AppRoutes {
  AppRoutes._();
  static final routerConfig = GoRouter(
    initialLocation: LoginPage.routeName,
    errorBuilder: (context, state) => RouteErrorPage(),
    routes: [
      GoRoute(
        path: LoginPage.routeName,
        name: LoginPage.routeName,
        builder: (context, state) => LoginPage(),
        redirect: (context, state) {
          if (UserStore.to.hasToken) {
            return HomePage.routeName;
          }
          return null;
        },
      ),
      GoRoute(
        path: HomePage.routeName,
        name: HomePage.routeName,
        builder: (context, state) => HomePage(),
      ),
      // GoRoute(
      //   path: ProfilePage.routeName,
      //   name: ProfilePage.routeName,
      //   builder: (context, state) => ProfilePage(),
      // ),
    ],
  );

  ///
  /// Navigator.of(context).pushNamed('/routeName')
  ///
  static Future<T?> push<T>(String to, [Object? args]) {
    return routerConfig.push<T>(to, extra: args);
  }

  ///
  /// Navigator.of(context).popAndPushNamed('/routeName')
  ///
  static Future<T?> popAndPush<T>(String to, [Object? args, Object? result]) {
    routerConfig.pop(result);
    return routerConfig.push<T>(to, extra: args);
  }

  ///
  /// Navigator.of(context).pop()
  ///
  static void pop<T extends Object?>([T? result]) {
    routerConfig.pop(result);
  }

  ///
  /// Navigator.of(context).pushNamedAndRemoveUntil('/routeName')
  ///
  static Future<T?> clearAllPush<T>(String to, [Object? args]) {
    while (routerConfig.canPop() == true) {
      routerConfig.pop();
    }
    return routerConfig.pushReplacement(to, extra: args);
  }

  static void go<T>(String to, [Object? args]) {
    routerConfig.go(to, extra: args);
  }

  static void popOrExit<T extends Object?>([T? result]) {
    AppRoutes.routerConfig.canPop()
        ? AppRoutes.routerConfig.pop(result)
        : exit(0);
  }

  static void setPageLanguage() {
    LanguageStore.to.addLanguageMap(LoginPageLanguage.languageMap);
  }
}

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key, this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    return Scaffold(body: Center(child: Text(error ?? state.error.toString())));
  }
}
