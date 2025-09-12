import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthUser {
  final String tenantId;
  final String userId;
  final String userName;

  const AuthUser({
    required this.tenantId,
    required this.userId,
    required this.userName,
  });
}

class AuthState {
  final bool isLoggedIn;
  final AuthUser? user;

  const AuthState({this.isLoggedIn = false, this.user});

  AuthState copyWith({bool? isLoggedIn, AuthUser? user}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }
}

class AuthService extends StateNotifier<AuthState> {
  AuthService() : super(const AuthState());

  Future<void> login({
    required String tenantId,
    required String userId,
    required String userName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = AuthUser(
      tenantId: tenantId,
      userId: userId,
      userName: userName,
    );
    state = state.copyWith(isLoggedIn: true, user: user);
  }

  void logout() {
    state = const AuthState();
  }

  bool get isLoggedIn => state.isLoggedIn;
  AuthUser? get user => state.user;
}
