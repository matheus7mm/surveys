import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:surveys/data/http/http.dart';
import 'package:surveys/main/decorators/decorators.dart';

import './../../data/mocks/mocks.dart';

void main() {
  late AuthorizeHttpClientDecorator sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late HttpClientSpy httpClient;
  late String url;
  late String method;
  late Map body;
  late String token;
  late String httpResponse;

  setUp(() {
    token = faker.guid.guid();
    httpResponse = faker.randomGenerator.string(50);
    secureCacheStorage = SecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    secureCacheStorage.mockFetch(token);
    httpClient.mockRequest(httpResponse);

    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: secureCacheStorage,
      deleteSecureCacheStorage: secureCacheStorage,
      decoratee: httpClient,
    );
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(
      url: url,
      method: method,
      body: body,
    );

    verify(() => secureCacheStorage.fetch('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(
      url: url,
      method: method,
      body: body,
    );
    verify(
      () => httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {
          'x-access-token': token,
        },
      ),
    ).called(1);

    await sut.request(
        url: url,
        method: method,
        body: body,
        headers: {'any_header': 'any_value'});
    verify(
      () => httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {
          'x-access-token': token,
          'any_header': 'any_value',
        },
      ),
    ).called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(
      url: url,
      method: method,
      body: body,
    );

    expect(
      response,
      httpResponse,
    );
  });

  test('Should throw ForbiddenError if FetchSecureCacheStorage throws',
      () async {
    secureCacheStorage.mockFetchError();

    final future = sut.request(
      url: url,
      method: method,
      body: body,
    );

    expect(future, throwsA(HttpError.forbidden));
    verify(() => secureCacheStorage.delete('token')).called(1);
  });

  test('Should rethrow if decoratee throws', () async {
    httpClient.mockRequestError(HttpError.badRequest);

    final future = sut.request(
      url: url,
      method: method,
      body: body,
    );

    expect(future, throwsA(HttpError.badRequest));
  });

  test('Should delete cache if request throws ForbiddenError', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.request(
      url: url,
      method: method,
      body: body,
    );
    await untilCalled(() => secureCacheStorage.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => secureCacheStorage.delete('token')).called(1);
  });
}
