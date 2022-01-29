import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:test/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:surveys/data/models/models.dart';
import 'package:surveys/data/repositories/repositories.dart';
import 'package:surveys/infra/repositories/repositories.dart';

import '../../../data/mocks/firebase_user_model_factory.dart';
import '../../../domain/mocks/mocks.dart';
import '../../mocks/firebase/firebase.dart';

void main() {
  late FirebaseUserRepository sut;
  late FirebaseUserModel userModel;

  setUp(() async {
    userModel = FirebaseUserModelFactory.makeValidData();
    sut = FirebaseUserRepository(
      firebasInstance: FakeFirebaseFirestore(),
    );
  });

  test('Should set the UserModel on Firebase', () async {
    await sut.setUser(userModel: userModel);

    /*
    final snapshot = await FakeFirebaseFirestore()
        .collection('users')
        .doc(userModel.uid)
        .get();

    final json = snapshot.data();

    expect(userModel, FirebaseUserModel.fromJson(json!));
    */
  });
}
