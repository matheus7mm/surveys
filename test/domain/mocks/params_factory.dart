import 'package:faker/faker.dart';
import 'package:surveys/domain/domain.dart';

class ParamsFactory {
  static AddAccountParams makeAddAccount() => AddAccountParams(
        name: faker.person.name(),
        email: faker.internet.email(),
        password: faker.internet.password(),
      );

  static AuthenticationParams makeAuthentication() => AuthenticationParams(
        email: faker.internet.email(),
        secret: faker.internet.password(),
      );
}
