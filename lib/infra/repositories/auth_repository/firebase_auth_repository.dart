import 'package:firebase_auth/firebase_auth.dart';

import './../../../domain/domain.dart';
import './../../../data/repositories/repositories.dart';

import './../helpers/helpers.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth auth; // FirebaseAuth.instance

  FirebaseAuthRepository({required this.auth});

  Future<AccountEntity> login({required AuthenticationParams params}) async {
    try {
      final FirebaseAuthenticationParams firebaseParams =
          FirebaseAuthenticationParams.fromDomain(params);

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: firebaseParams.email, password: firebaseParams.password);

      if (userCredential.user?.refreshToken != null) {
        return AccountEntity(token: userCredential.user!.refreshToken!);
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseExceptionError.notFound.toCode) {
        throw RepositoryError.notFound;
      } else if (e.code == FirebaseExceptionError.wrongPassword.toCode) {
        throw RepositoryError.forbidden;
      }

      throw Exception();
    } catch (error) {
      throw RepositoryError.badRequest;
    }
  }

  Future<AccountEntity> signUp({required AddAccountParams params}) async {
    try {
      final FirebaseRemoteAddAccountParams firebaseParams =
          FirebaseRemoteAddAccountParams.fromDomain(params);

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: firebaseParams.email, password: firebaseParams.password);

      if (userCredential.user?.refreshToken != null) {
        return AccountEntity(token: userCredential.user!.refreshToken!);
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseExceptionError.notFound.toCode) {
        throw RepositoryError.notFound;
      } else if (e.code == FirebaseExceptionError.emailInUse.toCode) {
        throw RepositoryError.forbidden;
      }

      throw Exception();
    } catch (error) {
      throw RepositoryError.badRequest;
    }
  }
}

class FirebaseAuthenticationParams {
  final String email;
  final String password;

  FirebaseAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory FirebaseAuthenticationParams.fromDomain(
          AuthenticationParams params) =>
      FirebaseAuthenticationParams(
        email: params.email,
        password: params.secret,
      );
}

class FirebaseRemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  FirebaseRemoteAddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory FirebaseRemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      FirebaseRemoteAddAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );
}
