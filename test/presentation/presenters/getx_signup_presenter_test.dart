import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/domain.dart';

import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import './../../domain/mocks/mocks.dart';
import './../mocks/mocks.dart';

void main() {
  late GetxSignUpPresenter sut;
  late AddAccountSpy addAccount;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;
  late AccountEntity account;

  setUp(() {
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = password;
    account = EntityFactory.makeAccount();
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    addAccount.mockAddAccount(account);
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      saveCurrentAccount: saveCurrentAccount,
      addAccount: addAccount,
    );
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAddAccount());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct email', () {
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null
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

  test('Should call Validation with correct name', () {
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null
    };

    sut.validateName(name);

    verify(
      () => validation.validate(
        field: 'name',
        input: formData,
      ),
    ).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(
      expectAsync1(
        (error) => expect(error, UIError.invalidField),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.nameErrorStream.listen(
      expectAsync1(
        (error) => expect(error, UIError.requiredField),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameErrorStream.listen(
      expectAsync1(
        (error) => expect(error, null),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null
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

  test('Should call Validation with correct passwordConfirmation', () {
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(
      () => validation.validate(
        field: 'passwordConfirmation',
        input: formData,
      ),
    ).called(1);
  });

  test('Should emit requiredFieldError if passwordConfirmation is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream.listen(
      expectAsync1(
        (error) => expect(error, UIError.requiredField),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validatePasswordConfirmation(password);
    sut.validatePasswordConfirmation(password);
  });

  test('Should emit passwordConfirmation error null if validation succeeds',
      () {
    sut.passwordConfirmationErrorStream.listen(
      expectAsync1(
        (error) => expect(error, null),
      ),
    );
    sut.isFormValidStream.listen(
      expectAsync1(
        (isValid) => expect(isValid, false),
      ),
    );

    sut.validatePasswordConfirmation(password);
    sut.validatePasswordConfirmation(password);
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

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(
      () => addAccount.add(
        AddAccountParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      ),
    ).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(
      () => saveCurrentAccount.save(account),
    ).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    saveCurrentAccount.mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(
      sut.mainErrorStream,
      emitsInAnyOrder([null, UIError.unexpected]),
    );
    expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    await sut.signUp();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(
      sut.mainErrorStream,
      emits(null),
    );
    expectLater(
      sut.isLoadingStream,
      emits(true),
    );

    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    addAccount.mockAddAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(
      sut.mainErrorStream,
      emitsInAnyOrder([null, UIError.emailInUse]),
    );
    expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    addAccount.mockAddAccountError(DomainError.unexpected);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(
      sut.mainErrorStream,
      emitsInAnyOrder([null, UIError.unexpected]),
    );
    expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen(
      expectAsync1(
        (page) => '/surveys',
      ),
    );

    await sut.signUp();
  });

  test('Should go to Login page on link click', () async {
    sut.navigateToStream.listen(
      expectAsync1(
        (page) => '/login',
      ),
    );

    sut.goToLogin();
  });
}
