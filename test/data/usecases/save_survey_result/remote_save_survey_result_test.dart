import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/domain.dart';

import 'package:surveys/data/usecases/usecases.dart';
import 'package:surveys/data/http/http.dart';

import './../../../infra/mocks/mocks.dart';
import './../../mocks/mocks.dart';

void main() {
  late RemoteSaveSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late String answer;
  late Map surveyResult;

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(
      url: url,
      httpClient: httpClient,
    );
    surveyResult = ApiFactory.makeSurveyResultJson();
    httpClient.mockRequest(surveyResult);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(
      () => httpClient.request(
        url: url,
        method: 'put',
        body: {'answer': answer},
      ),
    );
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.save(answer: answer);

    expect(
        result,
        SurveyResultEntity(
          surveyId: surveyResult['surveyId'],
          question: surveyResult['question'],
          answers: [
            SurveyAnswerEntity(
              image: surveyResult['answers'][0]['image'],
              answer: surveyResult['answers'][0]['answer'],
              isCurrentAnswer: surveyResult['answers'][0]
                  ['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][0]['percent'],
            ),
            SurveyAnswerEntity(
              answer: surveyResult['answers'][1]['answer'],
              isCurrentAnswer: surveyResult['answers'][1]
                  ['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][1]['percent'],
            ),
          ],
        ));
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });
}