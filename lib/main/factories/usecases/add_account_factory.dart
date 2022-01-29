import '../../../data/usecases/usecases.dart';
import '../../../domain/domain.dart';
import '../factories.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('signup'),
  );
}

AddAccount makeFirebaseRemoteAddAccount() {
  return FirebaseRemoteAddAccount(
    authRepository: makeAuthRepository(),
    userRepository: makeUserRepository(),
  );
}
