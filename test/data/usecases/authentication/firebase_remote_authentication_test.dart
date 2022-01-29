import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/domain.dart';

import 'package:surveys/data/repositories/repositories.dart';
import 'package:surveys/data/usecases/usecases.dart';

import './../../../domain/mocks/mocks.dart';
import './../../mocks/mocks.dart';

void main() {
  late FirebaseRemoteAuthentication sut;
  late UserRepositorySpy userRepository;
  late AuthenticationParams params;
  late AccountEntity accountEntity;

  setUp(() {
    userRepository = UserRepositorySpy();
    params = ParamsFactory.makeAuthentication();
    accountEntity = EntityFactory.makeAccount();
    userRepository.mockLogin(accountEntity);
    sut = FirebaseRemoteAuthentication(repository: userRepository);
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
  });

  test('Should call UserRepository with corret values', () async {
    await sut.auth(params);

    verify(
      () => userRepository.login(
        params: params,
      ),
    );
  });

  test('Should throw UnexpectedError if UserRepository throws badRequest',
      () async {
    userRepository.mockLoginError(RepositoryError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if UserRepository throws notFound',
      () async {
    userRepository.mockLoginError(RepositoryError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw ServerError if UserRepository throws serverError',
      () async {
    userRepository.mockLoginError(RepositoryError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Should throw InvalidCredentialsError if UserRepository throws unauthorized',
      () async {
    userRepository.mockLoginError(RepositoryError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if UserRepository returns data', () async {
    final account = await sut.auth(params);

    expect(account.token, accountEntity.token);
  });
}
