import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:surveys/presentation/mixins/mixins.dart';

import 'package:surveys/ui/helpers/helpers.dart';
import 'package:surveys/ui/pages/pages.dart';

import './../mocks/mocks.dart';
import './../helpers/helpers.dart';

void main() {
  late SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    await tester.pumpWidget(makePage(
        path: '/surveys', page: () => SurveysPage(presenter: presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should call LoadSurveys on reload', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo(
      NavigationState(
          route: 'any_route',
          onPop: (_) {
            presenter.loadData();
          }),
    );
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets(
    'Should handle loading correctly',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitLoading();
      await tester.pump(Duration.zero);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      presenter.emitLoading(false);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);

      presenter.emitLoading();
      await tester.pump(Duration.zero);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('Should present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();

    expect(
      find.text(UIError.unexpected.description),
      findsOneWidget,
    );
    expect(
      find.text(R.strings.reload),
      findsOneWidget,
    );
    expect(
      find.text('Question 1'),
      findsNothing,
    );
  });

  testWidgets('Should present list if loadSurveysStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
    await tester.pump();

    expect(
      find.text(UIError.unexpected.description),
      findsNothing,
    );
    expect(
      find.text(R.strings.reload),
      findsNothing,
    );
    expect(
      find.text('Question 1'),
      findsWidgets,
    );
    expect(
      find.text('Question 2'),
      findsWidgets,
    );
    expect(
      find.text('Date 1'),
      findsWidgets,
    );
    expect(
      find.text('Date 2'),
      findsWidgets,
    );
  });

  testWidgets('Should call LoadSurveys on reload button clickd',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.strings.reload));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets(
    'Should call goToSurveyResult on survey click',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitSurveys(ViewModelFactory.makeSurveyList());
      await tester.pump();

      await tester.tap(find.text('Question 1'));
      await tester.pump();

      verify(() => presenter.goToSurveyResult('1')).called(1);
    },
  );

  testWidgets(
    'Should change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitNavigateTo(NavigationState(route: '/any_route'));
      await tester.pumpAndSettle();

      expect(currentRoute, '/any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets(
    'Should not change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitNavigateTo(NavigationState(route: ''));
      await tester.pumpAndSettle();
      expect(currentRoute, '/surveys');
    },
  );

  testWidgets(
    'Should logout',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitSessionExpired();
      await tester.pumpAndSettle();

      expect(currentRoute, '/login');
      expect(find.text('fake login'), findsOneWidget);
    },
  );

  testWidgets(
    'Should not logout',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitSessionExpired(false);
      await tester.pumpAndSettle();
      expect(currentRoute, '/surveys');
    },
  );
}
