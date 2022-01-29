import 'package:mocktail/mocktail.dart';

import 'package:surveys/data/repositories/repositories.dart';
import 'package:surveys/domain/domain.dart';

class UserRepositorySpy extends Mock implements UserRepository {
  When mockLoginCall() => when(
        () => this.login(
          params: any(named: 'params'),
        ),
      );
  void mockLogin(AccountEntity data) =>
      this.mockLoginCall().thenAnswer((_) async => data);
  void mockLoginError(RepositoryError error) =>
      this.mockLoginCall().thenThrow(error);
}
