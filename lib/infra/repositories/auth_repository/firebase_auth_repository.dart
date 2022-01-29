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
