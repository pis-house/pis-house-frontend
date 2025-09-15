import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/pages/notice_page.dart';
import 'package:pis_house_frontend/pages/operational_status_page.dart';
import 'package:pis_house_frontend/pages/setting_page.dart';
import 'package:pis_house_frontend/pages/signin_page.dart';
import 'package:pis_house_frontend/pages/signup_page.dart';
import 'package:pis_house_frontend/pages/tab_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            TabPage(child: child),
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const MaterialPage(child: OperationalStatusPage()),
          ),
          GoRoute(
            path: '/notice',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const MaterialPage(child: NoticePage()),
          ),
          GoRoute(
            path: '/setting',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const MaterialPage(child: SettingPage()),
          ),
        ],
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SigninPage()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SignupPage()),
      ),
    ],
    redirect: (context, state) {
      final authService = ref.watch(authServiceProvider);
      final isSignInLocation = state.uri.toString() == '/signin';
      final isSignUpLocation = state.uri.toString() == '/signup';
      if (!authService.isSignIn && !isSignInLocation && !isSignUpLocation) {
        return '/signin';
      }
      return null;
    },
  );
});
