import 'package:mocktail/mocktail.dart';

import 'package:surveys/data/repositories/repositories.dart';
import 'package:surveys/domain/domain.dart';

class AuthRepositorySpy extends Mock implements AuthRepository {
  AuthRepositorySpy() {
    mockLogOut();
  }

  When mockLoginCall() => when(
        () => this.login(
          params: any(named: 'params'),
        ),
      );
  void mockLogin(AccountEntity data) =>
      this.mockLoginCall().thenAnswer((_) async => data);
  void mockLoginError(RepositoryError error) =>
      this.mockLoginCall().thenThrow(error);

  When mockLogOutCall() => when(
        () => this.logOut(),
      );
  void mockLogOut() => this.mockLogOutCall().thenAnswer((_) async => _);
  void mockLogOutError(Exception error) =>
      this.mockLogOutCall().thenThrow(error);
}
