import 'package:flutter/material.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              value: false,
              onChanged: (bool newValue) {},
            ),
          ),
          ListTile(
            title: Text('テーマカラー', style: TextStyle(fontSize: 20.0)),
            subtitle: Text('テーマカラーを設定', style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.person, size: 30),
            trailing: Icon(Icons.chevron_right, size: 30),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
