import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/common/pis_text_field.dart';

class SigninForm {
  String email;
  String password;
  String tenantName;

  SigninForm({this.email = '', this.password = '', this.tenantName = ''});

  SigninForm copyWith({String? email, String? password, String? tenantName}) {
    return SigninForm(
      email: email ?? this.email,
      password: password ?? this.password,
      tenantName: tenantName ?? this.tenantName,
    );
  }
}

class SigninPage extends HookConsumerWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useState(SigninForm());
    final colorContext = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth < 500
              ? constraints.maxWidth * 0.8
              : 500.0;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Piのいる家へようこそ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        PisTextField(
                          label: "テナント名",
                          onChanged: (value) {
                            formState.value = formState.value.copyWith(
                              tenantName: value,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        PisTextField(
                          label: "メールアドレス",
                          onChanged: (value) {
                            formState.value = formState.value.copyWith(
                              email: value,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        PisTextField(
                          label: "パスワード",
                          obscureText: true,
                          onChanged: (value) {
                            formState.value = formState.value.copyWith(
                              password: value,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: PisButton(
                            width: maxWidth * 0.5,
                            height: 40,
                            label: 'ログイン',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              context.go('/signup');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                            ),
                            child: Text(
                              'アカウントをお持ちでない方はこちら',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: colorContext.primaryColor,
                                color: colorContext.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
