import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:surveys/domain/domain.dart';

import 'package:surveys/ui/helpers/errors/errors.dart';
import 'package:surveys/presentation/presenters/presenters.dart';
import 'package:surveys/presentation/protocols/protocols.dart';

import './../../domain/mocks/mocks.dart';
import './../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String password;
  late AccountEntity account;

  setUp(() {
    account = EntityFactory.makeAccount();
    email = faker.internet.email();
    password = faker.internet.password();
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    authentication.mockAuthentication(account);
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct email', () {
    final formData = {
      'email': email,
      'password': null,
    };

    sut.validateEmail(email);

    verify(
      () => validation.validate(
        field: 'email',
        input: formData,
      ),
    ).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(
      expectAsync1(
        (error) => expect(error, UIError.invalidField),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.emailErrorStream.listen(
      expectAsync1(
        (error) => expect(error, UIError.requiredField),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(
      expectAsync1(
        (error) => expect(error, null),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      'email': null,
      'password': password,
    };

    sut.validatePassword(password);

    verify(
      () => validation.validate(
        field: 'password',
        input: formData,
      ),
    ).called(1);
  });

  test('Should emit requiredFieldError if password is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(
      expectAsync1(
        (error) => expect(error, UIError.requiredField),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error null if validation succeeds', () {
    sut.passwordErrorStream.listen(
      expectAsync1(
        (error) => expect(error, null),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should disable form button if any field is invalid', () {
    validation.mockValidationError(
        field: 'email', value: ValidationError.invalidField);

    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(
      sut.isFormValidStream,
      emitsInOrder([false, true]),
    );

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(
      () => authentication.auth(
        AuthenticationParams(email: email, secret: password),
      ),
    );
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(
      () => saveCurrentAccount.save(account),
    ).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    saveCurrentAccount.mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(
      sut.mainErrorStream,
      emitsInAnyOrder([null, UIError.unexpected]),
    );
    expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    await sut.auth();
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(
      sut.mainErrorStream,
      emits(null),
    );
    expectLater(
      sut.isLoadingStream,
      emits(true),
    );

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(
      expectAsync1(
        (page) => '/surveys',
      ),
    );

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(
      sut.mainErrorStream,
      emitsInAnyOrder([null, UIError.invalidCredentials]),
    );
    expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(
      sut.mainErrorStream,
      emitsInAnyOrder([null, UIError.unexpected]),
    );
    expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    await sut.auth();
  });

  test('Should go to SignUp page on link click', () async {
    sut.navigateToStream.listen(
      expectAsync1(
        (page) => '/signup',
      ),
    );

    sut.goToSignUp();
  });
}
