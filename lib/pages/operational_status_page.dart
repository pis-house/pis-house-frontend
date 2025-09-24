import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';

final tabsProvider = StateProvider<List<String>>(
  (ref) => ["リビング", "寝室", "トイレ"],
);

class OperationalStatusPage extends HookConsumerWidget {
  const OperationalStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tabs = ref.watch(tabsProvider);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PisBaseHeader(title: "タイトル"),
        body: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Container(
                color: theme.colorScheme.primary,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.white,
                  dividerColor: Colors.white,
                  tabs: tabs.map((name) => Tab(text: name)).toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: tabs
                    .map(
                      (name) => Center(
                        child: Text(name, style: const TextStyle(fontSize: 24)),
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PisButton(
                label: 'test',
                onPressed: () async {
                  ref
                      .read(tabsProvider.notifier)
                      .update((state) => [...state, "タブ${state.length + 1}"]);
                  await Future.delayed(const Duration(seconds: 5));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
