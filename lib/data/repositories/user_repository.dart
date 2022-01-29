import './../../domain/domain.dart';

abstract class UserRepository {
  Future<AccountEntity> login({required AuthenticationParams params});
}
