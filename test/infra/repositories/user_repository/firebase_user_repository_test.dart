import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:surveys/data/repositories/repositories.dart';
import 'package:surveys/domain/domain.dart';
import 'package:surveys/infra/repositories/repositories.dart';

import './../../../domain/mocks/mocks.dart';
import './../../mocks/firebase/firebase.dart';

void main() {
  late FirebaseUserRepository sut;
  late FirebaseAuthSpy auth;
  late MockUser mockUser;

  setUp(() async {
    mockUser = MockUserFactory.makeUser();
    auth = FirebaseAuthSpy();
    sut = FirebaseUserRepository(
      auth: auth,
    );
    auth.mockSignInWithEmailAndPassword(mockUser: mockUser);
  });

  setUpAll(() {});

  test('Should return a valid AccountEntity if authentication proceeds',
      () async {
    final AccountEntity result =
        await sut.login(params: ParamsFactory.makeValidAuthentication());

    expect(result.token, mockUser.refreshToken);
  });

  test('Should throw badRequest if authentication returns a null refreshToken',
      () async {
    auth.mockSignInWithEmailAndPassword(
        mockUser: MockUserFactory.makeUserWithInvalidToken());
    final future = sut.login(params: ParamsFactory.makeValidAuthentication());

    expect(future, throwsA(RepositoryError.badRequest));
  });

  test(
      'Should throw RepositoryError notFound if authentication throws FirebaseAuthException notFound',
      () async {
    auth.mockmockSignInWithEmailAndPasswordError(
        error: FirebaseAuthException(
            code: FirebaseExceptionError.notFound.toCode));
    final future = sut.login(params: ParamsFactory.makeValidAuthentication());

    expect(future, throwsA(RepositoryError.notFound));
  });

  test(
      'Should throw RepositoryError forbidden if authentication throws FirebaseAuthException wrongPassword',
      () async {
    auth.mockmockSignInWithEmailAndPasswordError(
        error: FirebaseAuthException(
            code: FirebaseExceptionError.wrongPassword.toCode));
    final future = sut.login(params: ParamsFactory.makeValidAuthentication());

    expect(future, throwsA(RepositoryError.forbidden));
  });

  test(
      'Should throw RepositoryError badRequest if authentication throws any exception',
      () async {
    auth.mockmockSignInWithEmailAndPasswordError(
        error: Exception('any_exception'));
    final future = sut.login(params: ParamsFactory.makeValidAuthentication());

    expect(future, throwsA(RepositoryError.badRequest));
  });
}
