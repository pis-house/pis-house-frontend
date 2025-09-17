import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';

class TabPage extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToTabIndex(location);
    final theme = Theme.of(context);
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[currentIndex].label),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 4.0,
        shadowColor: Colors.black26,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'ログアウト':
                  authService.signOut();
                  context.go('/signin');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'ログアウト', child: Text('ログアウト')),
            ],
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: currentIndex,
        items: _tabs
            .map(
              (_TabInfo tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                label: tab.label,
              ),
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
  const _TabInfo({required this.label, required this.icon, required this.path});
  final String label;
  final IconData icon;
  final String path;
}
