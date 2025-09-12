import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

class OperationalStatusPage extends HookConsumerWidget {
  const OperationalStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localCounter = useState(0);
    final globalCounter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Local & Global Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Global: $globalCounter",
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            Text(
              "Local: ${localCounter.value}",
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: () {
                localCounter.value++;
                ref.read(counterProvider.notifier).update((state) => state + 1);
              },
              child: const Text('カウント'),
            ),
          ],
        ),
      ),
    );
  }
}
