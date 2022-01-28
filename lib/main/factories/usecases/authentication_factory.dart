import './../../../data/usecases/usecases.dart';
import './../../../domain/domain.dart';
import './../factories.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login'),
  );
}
