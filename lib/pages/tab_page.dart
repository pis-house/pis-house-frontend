import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabPage extends HookConsumerWidget {
  const TabPage({super.key, required this.child});
  final Widget child;

  static final List<_TabInfo> _tabs = <_TabInfo>[
    const _TabInfo(icon: Icons.home, path: '/'),
    const _TabInfo(icon: Icons.notifications, path: '/notice'),
    const _TabInfo(icon: Icons.group, path: '/member'),
    const _TabInfo(icon: Icons.settings, path: '/setting'),
  ];

  int _locationToTabIndex(String location) {
    final Uri uri = Uri.parse(location);
    final String path = uri.path;

    for (int i = 0; i < _tabs.length; i++) {
      if (path == _tabs[i].path || path.startsWith('${_tabs[i].path}/')) {
        return i;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToTabIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: currentIndex,
        items: _tabs
            .map(
              (_TabInfo tab) =>
                  BottomNavigationBarItem(icon: Icon(tab.icon), label: ''),
            )
            .toList(),
        onTap: (int index) {
          context.go(_tabs[index].path);
        },
      ),
    );
  }
}

class _TabInfo {
  const _TabInfo({required this.icon, required this.path});
  final IconData icon;
  final String path;
}
