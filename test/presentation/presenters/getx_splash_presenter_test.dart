import 'package:surveys/presentation/mixins/navigation_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:surveys/presentation/presenters/presenters.dart';

import './../../domain/mocks/mocks.dart';

void main() {
  late GetxSplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAddAccount());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    loadCurrentAccount.mockLoad(account: EntityFactory.makeAccount());
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(
      expectAsync1(
        (page) => expect(page, NavigationState(route: '/surveys')),
      ),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    loadCurrentAccount.mockLoadError();

    sut.navigateToStream.listen(
      expectAsync1(
        (page) => expect(page, NavigationState(route: '/login')),
      ),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });
}
