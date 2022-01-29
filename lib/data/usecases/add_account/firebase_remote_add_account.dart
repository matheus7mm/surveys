import './../../../domain/entities/entities.dart';
import './../../../domain/helpers/helpers.dart';
import './../../../domain/usecases/usecases.dart';

import './../../repositories/repositories.dart';

class FirebaseRemoteAddAccount implements AddAccount {
  final AuthRepository authRepository;

  FirebaseRemoteAddAccount({
    required this.authRepository,
  });

  Future<AccountEntity> add(AddAccountParams params) async {
    try {
      final AccountEntity entity = await authRepository.signUp(params: params);

      return entity;
    } on RepositoryError catch (error) {
      error == RepositoryError.forbidden
          ? throw DomainError.emailInUse
          : throw DomainError.unexpected;
    }
  }
}
