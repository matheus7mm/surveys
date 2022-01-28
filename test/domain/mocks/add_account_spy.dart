import 'package:mocktail/mocktail.dart';

import 'package:surveys/domain/domain.dart';

class AddAccountSpy extends Mock implements AddAccount {
  When mockAddAccountCall() => when(() => this.add(any()));
  void mockAddAccount(AccountEntity data) =>
      this.mockAddAccountCall().thenAnswer((_) async => data);
  void mockAddAccountError(DomainError error) =>
      this.mockAddAccountCall().thenThrow(error);
}
