import 'package:takingnoteapp/services/auth/auth_provider.dart';
import 'package:takingnoteapp/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required String password,
    required String email,
  }) async {
    return await provider.createUser(
      password: password,
      email: email,
    );
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String password,
    required String email,
  }) async =>
      await provider.logIn(
        password: password,
        email: email,
      );

  @override
  Future<void> logOut() async {
    return await provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    return await provider.sendEmailVerification();
  }
}
