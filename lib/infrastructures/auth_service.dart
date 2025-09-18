import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/exceptions/tenant_exists_exception.dart';
import 'package:pis_house_frontend/exceptions/tenant_join_exception.dart';
import 'package:pis_house_frontend/exceptions/tenant_not_exists_exception.dart';
import 'package:pis_house_frontend/exceptions/tenant_not_join_exception.dart';
import 'package:pis_house_frontend/infrastructures/storage.dart';
import 'package:pis_house_frontend/repositories/firebases/tenant_repository.dart';
import 'package:pis_house_frontend/repositories/firebases/user_repository.dart';
import 'package:pis_house_frontend/repositories/interfaces/tenant_repository_interface.dart';
import 'package:pis_house_frontend/repositories/interfaces/user_repository_interface.dart';
import 'package:pis_house_frontend/schemas/tenant_model.dart';
import 'package:pis_house_frontend/schemas/user_model.dart';

class AuthUser {
  final String displayName;
  final String email;
  final String photoURL;
  final String tenantId;
  final String userId;

  const AuthUser({
    this.displayName = "",
    this.email = "",
    this.photoURL = "",
    this.tenantId = "",
    this.userId = "",
  });
}

class AuthState {
  final bool isSignIn;
  final AuthUser? user;

  const AuthState({this.isSignIn = false, this.user});

  AuthState copyWith({bool? isSignIn, AuthUser? user}) {
    return AuthState(
      isSignIn: isSignIn ?? this.isSignIn,
      user: user ?? this.user,
    );
  }
}

class AuthService extends StateNotifier<AuthState> {
  final TenantRepositoryInterface _tenantRepository;
  final UserRepositoryInterface _userRepository;
  late final StreamSubscription<User?> _authSubscription;

  AuthService({
    required TenantRepositoryInterface tenantRepository,
    required UserRepositoryInterface userRepository,
  }) : _tenantRepository = tenantRepository,
       _userRepository = userRepository,
       super(const AuthState()) {
    _authSubscription = FirebaseAuth.instance.idTokenChanges().listen(
      authChanged,
    );
  }

  Future<void> authChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      // 未ログイン or トークン失効
      state = const AuthState();
      return;
    }

    final storageTenantId = await StorageService.instance.read(key: 'tenantId');
    if (storageTenantId == null || storageTenantId.isEmpty) {
      return;
    }
    final tenant = await _tenantRepository.firstByTenantId(storageTenantId);
    if (tenant == null) {
      state = const AuthState();
      return;
    }

    final user = await _userRepository.firstByTenantIdAndUserId(
      tenant.id,
      firebaseUser.uid,
    );
    if (user == null) {
      state = const AuthState();
      return;
    }

    state = state.copyWith(
      isSignIn: true,
      user: AuthUser(
        displayName: user.displayName,
        email: firebaseUser.email ?? "",
        photoURL: firebaseUser.photoURL ?? "",
        tenantId: tenant.id,
        userId: firebaseUser.uid,
      ),
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> createTenantAndUser({
    required String displayName,
    required String email,
    required String password,
    required String tenantName,
  }) async {
    final tenant = await _tenantRepository.firstByTenantName(tenantName);
    if (tenant != null) {
      throw TenantExistsException();
    }
    late UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      if (e.code != 'email-already-in-use') {
        rethrow;
      }
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    final newTenant = await _tenantRepository.create(
      TenantModel.create(name: tenantName),
    );
    await _userRepository.create(
      newTenant.id,
      UserModel.create(
        id: credential.user!.uid,
        displayName: displayName,
        isAdmin: true,
        preferredAirconTemperature: 0,
        preferredLightBrightnessPercent: 0,
      ),
    );
    state = state.copyWith(
      isSignIn: true,
      user: AuthUser(
        displayName: displayName,
        email: credential.user!.email ?? "",
        photoURL: credential.user!.photoURL ?? "",
        tenantId: newTenant.id,
        userId: credential.user!.uid,
      ),
    );
  }

  Future<void> createUserAndJoinTenant({
    required String displayName,
    required String email,
    required String password,
    required String tenantName,
  }) async {
    final joinTenant = await _tenantRepository.firstByTenantName(tenantName);
    if (joinTenant == null) {
      throw TenantNotExistsException();
    }
    late UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      if (e.code != 'email-already-in-use') {
        rethrow;
      }
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    final existsUser = await _userRepository.firstByTenantIdAndUserId(
      joinTenant.id,
      credential.user!.uid,
    );
    if (existsUser != null) {
      throw TenantJoinException();
    }
    final newUser = await _userRepository.create(
      joinTenant.id,
      UserModel.create(
        id: credential.user!.uid,
        displayName: displayName,
        isAdmin: false,
        preferredAirconTemperature: 0,
        preferredLightBrightnessPercent: 0,
      ),
    );
    state = state.copyWith(
      isSignIn: true,
      user: AuthUser(
        displayName: newUser.displayName,
        email: credential.user!.email ?? "",
        photoURL: credential.user!.photoURL ?? "",
        tenantId: joinTenant.id,
        userId: credential.user!.uid,
      ),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
    required String tenantName,
  }) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final existsTenant = await _tenantRepository.firstByTenantName(tenantName);
    if (existsTenant == null) {
      throw TenantNotExistsException();
    }
    final existUser = await _userRepository.firstByTenantIdAndUserId(
      existsTenant.id,
      credential.user!.uid,
    );
    if (existUser == null) {
      throw TenantNotJoinException();
    }
    final user = AuthUser(
      displayName: existUser.displayName,
      email: credential.user!.email ?? "",
      photoURL: credential.user!.photoURL ?? "",
      tenantId: existsTenant.id,
      userId: existUser.id,
    );
    state = state.copyWith(isSignIn: true, user: user);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = const AuthState();
  }

  bool get isSignIn => state.isSignIn;
  AuthUser? get user => state.user;
}

final authServiceProvider = Provider<AuthService>((ref) {
  final tenantRepository = ref.watch(tenantRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return AuthService(
    tenantRepository: tenantRepository,
    userRepository: userRepository,
  );
});
