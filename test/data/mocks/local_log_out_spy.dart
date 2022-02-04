import 'package:mocktail/mocktail.dart';

import 'package:surveys/data/usecases/usecases.dart';
import 'package:surveys/domain/domain.dart';

class LocalLogOutSpy extends Mock implements LocalLogOut {
  LocalLogOutSpy() {
    mockLogOut();
  }

  When mockLogOutCall() => when(() => this.logOut());
  void mockLogOut() => mockLogOutCall().thenAnswer((_) async => _);
  void mockLogOutError() => mockLogOutCall().thenThrow(DomainError.unexpected);
}
