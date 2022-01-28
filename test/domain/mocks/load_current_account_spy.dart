import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/domain.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCall() => when(() => this.load());
  void mockLoad({required AccountEntity account}) =>
      this.mockLoadCall().thenAnswer((_) async => account);
  void mockLoadError() => this.mockLoadCall().thenThrow(Exception());
}
