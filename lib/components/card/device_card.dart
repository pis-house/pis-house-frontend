import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeviceCard extends HookConsumerWidget {
  final bool isActive;
  final double interval;
  final double minSliderValue;
  final double maxSliderValue;
  final Function() onDelete;
  final Function() onEdit;
  final Function(double) onSliderValueChanged;
  final Function(bool) onIsActiveChanged;
  final IconData sliderIcon;
  final double sliderValue;
  final String title;
  final IconData titleIcon;
  final String unitName;

  const DeviceCard({
    super.key,
    required this.isActive,
    required this.minSliderValue,
    required this.maxSliderValue,
    required this.onDelete,
    required this.onEdit,
    required this.onSliderValueChanged,
    required this.onIsActiveChanged,
    required this.sliderIcon,
    required this.title,
    required this.titleIcon,
    required this.unitName,
    required this.sliderValue,
    required this.interval,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // コンストラクタから受け取った初期値でStateを初期化
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.6,
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                titleIcon,
                size: 40,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.disabledColor,
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'edit', child: Text('編集')),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('削除'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            if (isActive)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(sliderIcon, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Slider(
                        value: sliderValue,
                        min: minSliderValue,
                        max: maxSliderValue,
                        onChanged: onSliderValueChanged,
                        divisions:
                            ((maxSliderValue - minSliderValue) / interval)
                                .round(),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${sliderValue.toStringAsFixed(1)}$unitName',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            SwitchListTile(
              title: Text(
                isActive ? '起動中' : '停止中',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.green : Colors.red,
                ),
              ),
              value: isActive,
              onChanged: onIsActiveChanged,
              activeTrackColor: theme.colorScheme.primary.withAlpha(128),
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
