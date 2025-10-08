import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/pages/create_device_page.dart';
import 'package:pis_house_frontend/pages/create_indoor_area_page.dart';
import 'package:pis_house_frontend/pages/edit_indoor_area_page.dart';
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
      GoRoute(
        path: '/create-indoor-area',
        pageBuilder: (context, state) =>
            MaterialPage(child: CreateIndoorAreaPage()),
      ),
      GoRoute(
        path: '/edit-indoor-area/:areaId',
        pageBuilder: (context, state) {
          final areaId = state.pathParameters['areaId']!;
          return MaterialPage(child: EditIndoorAreaPage(indoorAreaId: areaId));
        },
      ),
      GoRoute(
        path: '/indoor-area/:areaId/create-device',
        pageBuilder: (context, state) {
          final areaId = state.pathParameters['areaId']!;
          return MaterialPage(child: CreateDevicePage(indoorAreaId: areaId));
        },
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

CustomTransitionPage<T> createSlideUpTransitionPage<T>({
  required LocalKey key,
  required Widget child,
  bool fullscreenDialog = true,
}) {
  return CustomTransitionPage<T>(
    key: key,
    fullscreenDialog: fullscreenDialog,
    child: child,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          final CurvedAnimation curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
            reverseCurve: Curves.ease,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
  );
}
