import 'package:faker/faker.dart';
import 'package:surveys/data/models/models.dart';

class FirebaseUserModelFactory {
  static FirebaseUserModel makeValidData() => FirebaseUserModel(
        refreshToken: faker.jwt.valid(),
        uid: faker.guid.guid(),
        email: faker.internet.email(),
        name: faker.person.firstName(),
      );
}
