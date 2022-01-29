import './../../domain/domain.dart';

abstract class AuthRepository {
  Future<AccountEntity> login({required AuthenticationParams params});

  Future<AccountEntity> signUp({required AddAccountParams params});
}
