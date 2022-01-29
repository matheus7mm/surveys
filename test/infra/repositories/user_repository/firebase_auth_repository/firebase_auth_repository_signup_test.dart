import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:surveys/data/repositories/repositories.dart';
import 'package:surveys/domain/domain.dart';
import 'package:surveys/infra/repositories/repositories.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../mocks/firebase/firebase.dart';

void main() {
  // SignUp test
  late FirebaseAuthRepository sut;
  late FirebaseAuthSpy auth;
  late MockUser mockUser;

  setUp(() async {
    mockUser = MockUserFactory.makeUser();
    auth = FirebaseAuthSpy();
    sut = FirebaseAuthRepository(
      auth: auth,
    );
    auth.mockCreateUserWithEmailAndPassword(mockUser: mockUser);
  });

  test('Should return a valid AccountEntity if sign up proceeds', () async {
    final AccountEntity result =
        await sut.signUp(params: ParamsFactory.makeAddAccount());

    expect(result.token, mockUser.refreshToken);
  });

  test('Should throw badRequest if sign up returns a null refreshToken',
      () async {
    auth.mockCreateUserWithEmailAndPassword(
        mockUser: MockUserFactory.makeUserWithInvalidToken());
    final future = sut.signUp(params: ParamsFactory.makeAddAccount());

    expect(future, throwsA(RepositoryError.badRequest));
  });

  test(
      'Should throw RepositoryError notFound if sign up throws FirebaseAuthException notFound',
      () async {
    auth.mockCreateUserWithEmailAndPasswordError(
        error: FirebaseAuthException(
            code: FirebaseExceptionError.notFound.toCode));
    final future = sut.signUp(params: ParamsFactory.makeAddAccount());

    expect(future, throwsA(RepositoryError.notFound));
  });

  test(
      'Should throw RepositoryError forbidden if sign up throws FirebaseAuthException emailInUse',
      () async {
    auth.mockCreateUserWithEmailAndPasswordError(
        error: FirebaseAuthException(
            code: FirebaseExceptionError.emailInUse.toCode));
    final future = sut.signUp(params: ParamsFactory.makeAddAccount());

    expect(future, throwsA(RepositoryError.forbidden));
  });

  test(
      'Should throw RepositoryError badRequest if sign up throws any exception',
      () async {
    auth.mockCreateUserWithEmailAndPasswordError(
        error: Exception('any_exception'));
    final future = sut.signUp(params: ParamsFactory.makeAddAccount());

    expect(future, throwsA(RepositoryError.badRequest));
  });
}
