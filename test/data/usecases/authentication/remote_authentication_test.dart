import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/domain/usecases/usecases.dart';

import 'package:surveys/data/http/http.dart';
import 'package:surveys/data/usecases/usecases.dart';

import './../../../infra/mocks/mocks.dart';
import './../../../domain/mocks/mocks.dart';
import './../../mocks/mocks.dart';

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;
  late Map apiResult;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    params = ParamsFactory.makeAuthentication();
    apiResult = ApiFactory.makeAccountJson();
    httpClient.mockRequest(apiResult);
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with corret values', () async {
    await sut.auth(params);

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
        body: {
          'email': params.email,
          'password': params.secret,
        },
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    httpClient.mockRequestError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw ServerError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    httpClient.mockRequestError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final account = await sut.auth(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    httpClient.mockRequest({
      'invalid_key': 'invalid_value',
    });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
