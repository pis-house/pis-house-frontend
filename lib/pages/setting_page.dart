import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PisBaseHeader(title: "設定"),
      body: ListView(
        children: [
          ListTile(
            title: Text('アカウント', style: TextStyle(fontSize: 20.0)),
            subtitle: Text('ユーザー名の変更', style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.person, size: 30),
            trailing: Icon(Icons.chevron_right, size: 30),
            onTap: () {
              context.push('/account-setting');
            },
          ),
          ListTile(
            title: Text('テーマ', style: TextStyle(fontSize: 20.0)),
            subtitle: Text('テーマカラーの変更', style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.person, size: 30),
            trailing: Icon(Icons.chevron_right, size: 30),
            onTap: () {
              context.push('/theme-setting');
            },
          ),
        ],
      ),
    );
  }
}
