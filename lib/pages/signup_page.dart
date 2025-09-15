import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/common/pis_error_snack_bar.dart';
import 'package:pis_house_frontend/components/common/pis_text_field.dart';
import 'package:pis_house_frontend/exceptions/tenant_exists_exception.dart';
import 'package:pis_house_frontend/exceptions/tenant_join_exception.dart';
import 'package:pis_house_frontend/exceptions/tenant_not_exists_exception.dart';
import 'package:pis_house_frontend/exceptions/tenant_not_join_exception.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';

enum SignupTenantType { create, join }

class SignupPage extends HookConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final emailController = useTextEditingController();
    final nickNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final tenantNameController = useTextEditingController();
    final theme = Theme.of(context);
    final authService = ref.watch(authServiceProvider);
    final signupTenantTypeTab = const <SignupTenantType, Widget>{
      SignupTenantType.create: Text('テナント作成'),
      SignupTenantType.join: Text('テナント参加'),
    };
    final currentSignupTenantType = useState(SignupTenantType.create);
    final isSignupButtonLoading = useState(false);

    return Scaffold(
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
                              'Piのいる家\nアカウントを作成する',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            CupertinoSlidingSegmentedControl<SignupTenantType>(
                              groupValue: currentSignupTenantType.value,
                              children: signupTenantTypeTab,
                              onValueChanged: (SignupTenantType? type) {
                                if (type != null) {
                                  currentSignupTenantType.value = type;
                                }
                              },
                            ),
                            const SizedBox(height: 25),
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
                              label: "ニックネーム",
                              controller: nickNameController,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'を入力してください。'
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
                            const SizedBox(height: 40),
                            Align(
                              alignment: Alignment.center,
                              child: PisButton(
                                label: 'アカウント登録',
                                isLoading: isSignupButtonLoading.value,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    isSignupButtonLoading.value = true;
                                    final email = emailController.text;
                                    final nickName = nickNameController.text;
                                    final password = passwordController.text;
                                    final tenantName =
                                        tenantNameController.text;
                                    try {
                                      if (currentSignupTenantType.value ==
                                          SignupTenantType.create) {
                                        await authService.createTenantAndUser(
                                          displayName: nickName,
                                          email: email,
                                          password: password,
                                          tenantName: tenantName,
                                        );
                                      }
                                      if (currentSignupTenantType.value ==
                                          SignupTenantType.join) {
                                        await authService
                                            .createUserAndJoinTenant(
                                              displayName: nickName,
                                              email: email,
                                              password: password,
                                              tenantName: tenantName,
                                            );
                                      }
                                    } on TenantNotExistsException catch (e) {
                                      if (!context.mounted) return;
                                      PisErrorSnackBar(
                                        e.toString(),
                                      ).show(context);
                                    } on TenantNotJoinException catch (e) {
                                      if (!context.mounted) return;
                                      PisErrorSnackBar(
                                        e.toString(),
                                      ).show(context);
                                    } on TenantJoinException catch (e) {
                                      if (!context.mounted) return;
                                      PisErrorSnackBar(
                                        e.toString(),
                                      ).show(context);
                                    } on TenantExistsException catch (e) {
                                      if (!context.mounted) return;
                                      PisErrorSnackBar(
                                        e.toString(),
                                      ).show(context);
                                    } on Exception {
                                      if (!context.mounted) return;
                                      PisErrorSnackBar(
                                        '不明なエラーが発生しました',
                                      ).show(context);
                                    }
                                    isSignupButtonLoading.value = false;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  context.go('/signin');
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: Text(
                                  'アカウントをお持ちの方はこちら',
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
