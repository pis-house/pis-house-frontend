import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/card/device_card.dart';

class AirconCard extends HookConsumerWidget {
  final bool isActive;
  final Function() onDelete;
  final Function() onEdit;
  final Function(bool) onIsActiveChanged;
  final Function(double) onSliderValueChangeEnd;
  final Function(double) onSliderValueChanged;
  final double temperature;
  final String title;

  const AirconCard({
    super.key,
    required this.isActive,
    required this.onDelete,
    required this.onEdit,
    required this.onIsActiveChanged,
    required this.onSliderValueChangeEnd,
    required this.onSliderValueChanged,
    required this.temperature,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeviceCard(
      title: title,
      titleIcon: Icons.ac_unit,
      sliderIcon: Icons.thermostat,
      unitName: '℃',
      minSliderValue: 18.0,
      maxSliderValue: 30.0,
      isActive: isActive,
      sliderValue: temperature,
      interval: 0.5,
      onDelete: onDelete,
      onEdit: onEdit,
      onSliderValueChangeEnd: onSliderValueChangeEnd,
      onIsActiveChanged: onIsActiveChanged,
      onSliderValueChanged: onSliderValueChanged,
    );
  }
}
