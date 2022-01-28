import 'package:surveys/presentation/mixins/navigation_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:surveys/presentation/presenters/presenters.dart';
import 'package:surveys/domain/domain.dart';
import 'package:surveys/ui/helpers/helpers.dart';
import 'package:surveys/ui/pages/pages.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late GetxSurveysPresenter sut;
  late LoadSurveysSpy loadSurveys;

  List<SurveyEntity> surveys;

  setUp(() {
    surveys = EntityFactory.makeSurveyList();
    loadSurveys = LoadSurveysSpy();
    loadSurveys.mockLoad(surveys);
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(
      sut.isLoadingStream,
      emitsInOrder([
        true,
        false,
      ]),
    );
    sut.surveysStream.listen(
      expectAsync1(
        (surveys) => expect(surveys, [
          SurveyViewModel(
            id: surveys[0].id,
            question: surveys[0].question,
            date: '02 Feb 2020',
            didAnswer: surveys[0].didAnswer,
          ),
          SurveyViewModel(
            id: surveys[1].id,
            question: surveys[1].question,
            date: '01 Jan 2019',
            didAnswer: surveys[1].didAnswer,
          )
        ]),
      ),
    );

    await sut.loadData();
  });

  test('Should emit correct events on access denied', () async {
    loadSurveys.mockLoadError(DomainError.accessDenied);

    expectLater(
      sut.isLoadingStream,
      emitsInOrder([
        true,
        false,
      ]),
    );
    expectLater(
      sut.isSessionExpiredStream,
      emits(true),
    );

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    loadSurveys.mockLoadError(DomainError.unexpected);

    expectLater(
        sut.isLoadingStream,
        emitsInOrder([
          true,
          false,
        ]));
    sut.surveysStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(
          error,
          UIError.unexpected.description,
        ),
      ),
    );

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey click', () async {
    expectLater(
        sut.navigateToStream,
        emitsInOrder([
          NavigationState(
              route: '/survey_result/any_route',
              onPop: (_) {
                sut.loadData();
              }),
          NavigationState(
              route: '/survey_result/any_route',
              onPop: (_) {
                sut.loadData();
              }),
        ]));

    sut.goToSurveyResult('any_route');
    sut.goToSurveyResult('any_route');
  });
}
