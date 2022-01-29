import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseAuthSpy extends Mock implements FirebaseAuth {
  When mockSignInWithEmailAndPasswordCall() =>
      when(() => this.signInWithEmailAndPassword(
          email: any(named: 'email'), password: any(named: 'password')));
  void mockSignInWithEmailAndPassword({
    required MockUser mockUser,
  }) =>
      this.mockSignInWithEmailAndPasswordCall().thenAnswer((_) async =>
          MockFirebaseAuth(mockUser: mockUser)
              .signInWithEmailAndPassword(email: '', password: ''));
  void mockmockSignInWithEmailAndPasswordError({required Exception error}) =>
      this.mockSignInWithEmailAndPasswordCall().thenThrow(error);
}
