import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:surveys/data/repositories/repositories.dart';
import 'package:surveys/domain/domain.dart';
import 'package:surveys/infra/repositories/repositories.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../mocks/firebase/firebase.dart';

void main() {
  // Login test
  late FirebaseAuthRepository sut;
  late FirebaseAuthSpy auth;
  late MockUser mockUser;

  setUp(() async {
    mockUser = MockUserFactory.makeUser();
    auth = FirebaseAuthSpy();
    sut = FirebaseAuthRepository(
      auth: auth,
    );
    auth.mockSignInWithEmailAndPassword(mockUser: mockUser);
  });

  test('Should return a valid AccountEntity if authentication proceeds',
      () async {
    final AccountEntity result =
        await sut.login(params: ParamsFactory.makeAuthentication());

    expect(result.token, mockUser.refreshToken);
  });

  test('Should throw badRequest if authentication returns a null refreshToken',
      () async {
    auth.mockSignInWithEmailAndPassword(
        mockUser: MockUserFactory.makeUserWithInvalidToken());
    final future = sut.login(params: ParamsFactory.makeAuthentication());

    expect(future, throwsA(RepositoryError.badRequest));
  });

  test(
      'Should throw RepositoryError notFound if authentication throws FirebaseAuthException notFound',
      () async {
    auth.mockSignInWithEmailAndPasswordError(
        error: FirebaseAuthException(
            code: FirebaseExceptionError.notFound.toCode));
    final future = sut.login(params: ParamsFactory.makeAuthentication());

    expect(future, throwsA(RepositoryError.notFound));
  });

  test(
      'Should throw RepositoryError forbidden if authentication throws FirebaseAuthException wrongPassword',
      () async {
    auth.mockSignInWithEmailAndPasswordError(
        error: FirebaseAuthException(
            code: FirebaseExceptionError.wrongPassword.toCode));
    final future = sut.login(params: ParamsFactory.makeAuthentication());

    expect(future, throwsA(RepositoryError.forbidden));
  });

  test(
      'Should throw RepositoryError badRequest if authentication throws any exception',
      () async {
    auth.mockSignInWithEmailAndPasswordError(error: Exception('any_exception'));
    final future = sut.login(params: ParamsFactory.makeAuthentication());

    expect(future, throwsA(RepositoryError.badRequest));
  });
}
