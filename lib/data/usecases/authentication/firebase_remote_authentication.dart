import './../../../domain/entities/entities.dart';
import './../../../domain/helpers/helpers.dart';
import './../../../domain/usecases/usecases.dart';

import './../../repositories/repositories.dart';

class FirebaseRemoteAuthentication implements Authentication {
  final UserRepository repository;

  FirebaseRemoteAuthentication({
    required this.repository,
  });

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final AccountEntity entity = await repository.login(params: params);

      return entity;
    } on RepositoryError catch (error) {
      error == RepositoryError.unauthorized
          ? throw DomainError.invalidCredentials
          : throw DomainError.unexpected;
    }
  }
}

class FirebaseRemoteAuthenticationParams {
  final String email;
  final String password;

  FirebaseRemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory FirebaseRemoteAuthenticationParams.fromDomain(
          AuthenticationParams params) =>
      FirebaseRemoteAuthenticationParams(
        email: params.email,
        password: params.secret,
      );

  Map toJson() => {'email': email, 'password': password};
}
