import 'package:test/test.dart';

import 'package:surveys/main/factories/factories.dart';
import 'package:surveys/validation/validators/validators.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();

    expect(
      validations,
      [
        RequiredFieldValidation('name'),
        MinLengthValidation(
          field: 'name',
          size: 3,
        ),
        RequiredFieldValidation('email'),
        EmailValidation('email'),
        RequiredFieldValidation('password'),
        MinLengthValidation(
          field: 'password',
          size: 3,
        ),
      ],
    );
  });
}
