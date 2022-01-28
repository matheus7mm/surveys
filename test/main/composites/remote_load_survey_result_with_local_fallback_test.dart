import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:surveys/domain/domain.dart';
import 'package:surveys/main/composites/composites.dart';

import '../../domain/mocks/mocks.dart';
import './../../data/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late String surveyId;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    remoteResult = EntityFactory.makeSurveyResult();
    localResult = EntityFactory.makeSurveyResult();
    remote.mockLoadBySurvey(remoteResult);
    local.mockLoadBySurvey(localResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(
          surveyId: surveyId,
        )).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(
          surveyResult: remoteResult,
        )).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccesssDenied error',
      () async {
    remote.mockLoadBySurveyError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call load LoadBySurvey on remote error', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('Should throw UnexpectedError if local load fails', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    local.mockLoadBySurveyError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
