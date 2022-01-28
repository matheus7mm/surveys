import './translations.dart';

class EnUs implements Translations {
  String get msgEmailInUse => 'The email is in use';
  String get msgInvalidCredentials => 'Invalid Credentials';
  String get msgInvalidField => 'Invalid Field';
  String get msgRequiredField => 'Required Field';
  String get msgUnexpected => 'Something went wrong. Try again later.';

  String get addAccount => 'Add Account';
  String get confirmPassword => 'Confirm password';
  String get email => 'Email';
  String get enter => 'Enter';
  String get login => 'Login';
  String get name => 'Name';
  String get password => 'Password';
  String get reload => 'Reload';
  String get surveys => 'Surveys';
  String get wait => 'Wait...';
}
