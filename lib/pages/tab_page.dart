import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabPage extends StatelessWidget {
  const TabPage({super.key, required this.child});
  final Widget child;

  static final List<_TabInfo> _tabs = <_TabInfo>[
    const _TabInfo(label: '稼働状況', icon: Icons.home, path: '/'),
    const _TabInfo(label: '通知', icon: Icons.notifications, path: '/notice'),
    const _TabInfo(label: '設定', icon: Icons.settings, path: '/setting'),
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
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int currentIndex = _locationToTabIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: currentIndex,
        items: _tabs
            .map((_TabInfo tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ))
            .toList(),
        onTap: (int index) {
          context.go(_tabs[index].path);
        },
      ),
    );
  }
}

class _TabInfo {
  const _TabInfo({
    required this.label,
    required this.icon,
    required this.path,
  });
  final String label;
  final IconData icon;
  final String path;
}
