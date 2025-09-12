import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pis_house_frontend/pages/notice_page.dart';
import 'package:pis_house_frontend/pages/operational_status_page.dart';
import 'package:pis_house_frontend/pages/setting_page.dart';
import 'package:pis_house_frontend/pages/tab_page.dart';

final GoRouter router = GoRouter(
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
  ],
);
