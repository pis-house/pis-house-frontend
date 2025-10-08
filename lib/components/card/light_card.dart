import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/card/device_card.dart';

class LightCard extends HookConsumerWidget {
  final double brightness;
  final bool isActive;
  final Function() onDelete;
  final Function() onEdit;
  final Function(bool) onIsActiveChanged;
  final Function(double) onSliderValueChanged;
  final String title;

  const LightCard({
    super.key,
    required this.brightness,
    required this.isActive,
    required this.onDelete,
    required this.onEdit,
    required this.onIsActiveChanged,
    required this.onSliderValueChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeviceCard(
      title: title,
      titleIcon: Icons.lightbulb_outline,
      sliderIcon: Icons.brightness_6,
      unitName: '%',
      minSliderValue: 0.0,
      maxSliderValue: 100.0,
      interval: 10,
      isActive: isActive,
      sliderValue: brightness,
      onDelete: onDelete,
      onEdit: onEdit,
      onIsActiveChanged: onIsActiveChanged,
      onSliderValueChanged: onSliderValueChanged,
    );
  }
}
