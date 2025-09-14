import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/common/pis_error_snack_bar.dart';
import 'package:pis_house_frontend/components/common/pis_text_field.dart';
import 'package:pis_house_frontend/exceptions/tenant_not_exists_exception.dart';
import 'package:pis_house_frontend/exceptions/tenant_not_join_exception.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';

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

class SigninPage extends ConsumerWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final tenantNameController = TextEditingController();
    final theme = Theme.of(context);
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Piのいる家\nログインする',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            PisTextFormField(
                              label: "テナント名",
                              controller: tenantNameController,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'テナント名を入力してください。'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            PisTextFormField(
                              label: "メールアドレス",
                              controller: emailController,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'メールアドレスを入力してください。'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            PisTextFormField(
                              label: "パスワード",
                              obscureText: true,
                              controller: passwordController,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'パスワードを入力してください。'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.center,
                              child: PisButton(
                                label: 'ログイン',
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    final email = emailController.text;
                                    final password = passwordController.text;
                                    final tenantName =
                                        tenantNameController.text;
                                    try {
                                      await authService.signIn(
                                        email: email,
                                        password: password,
                                        tenantName: tenantName,
                                      );
                                    } on TenantNotExistsException catch (e) {
                                      PisErrorSnackBar(
                                        e.toString(),
                                      ).show(context);
                                    } on TenantNotJoinException catch (e) {
                                      PisErrorSnackBar(
                                        e.toString(),
                                      ).show(context);
                                    } on Exception {
                                      PisErrorSnackBar(
                                        '不明なエラーが発生しました',
                                      ).show(context);
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  context.go('/signup');
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: Text(
                                  'アカウントをお持ちでない方はこちら',
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    decorationColor: theme.primaryColor,
                                    color: theme.primaryColor,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
