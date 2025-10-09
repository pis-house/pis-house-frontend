import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/infrastructures/storage.dart';
import 'package:pis_house_frontend/theme.dart';

class ThemeSettingPage extends HookConsumerWidget {
  const ThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeDataColorScheme = ref.watch(themeDataColorSchemeProvider);
    final enableDarkMode = useState(
      themeDataColorScheme.brightness == Brightness.dark,
    );

    final selectedColor = useState(theme.colorScheme.primary);

    return Scaffold(
      appBar: PisBaseHeader(title: "テーマ設定"),
      body: ListView(
        children: [
          ListTile(
            title: Text('ダークモード', style: TextStyle(fontSize: 20.0)),
            subtitle: Text('ダークモードに設定', style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.dark_mode, size: 30),
            trailing: Switch(
              activeTrackColor: theme.colorScheme.primary.withAlpha(128),
              activeColor: theme.colorScheme.primary,
              value: enableDarkMode.value,
              onChanged: (bool enable) async {
                if (enable) {
                  ref.read(themeDataColorSchemeProvider.notifier).darkMode();
                } else {
                  ref.read(themeDataColorSchemeProvider.notifier).lightMode();
                }
                enableDarkMode.value = enable;
                StorageService.instance.write(
                  key: 'brightness',
                  value: (enable ? Brightness.dark : Brightness.light)
                      .toString(),
                );
              },
            ),
          ),
          ListTile(
            title: Text('テーマカラー', style: TextStyle(fontSize: 20.0)),
            subtitle: Text('テーマカラーを設定', style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.color_lens, size: 30),
            trailing: Icon(Icons.chevron_right, size: 30),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('テーマカラーを選択'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: selectedColor.value,
                        onColorChanged: (color) {
                          ref
                              .read(themeDataColorSchemeProvider.notifier)
                              .changeSeedColor(color);
                          selectedColor.value = color;
                          StorageService.instance.write(
                            key: 'seedColor',
                            value: color.toHexString(),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
