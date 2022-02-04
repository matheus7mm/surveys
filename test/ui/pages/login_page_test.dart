import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:surveys/presentation/mixins/mixins.dart';
import 'package:surveys/ui/helpers/helpers.dart';
import 'package:surveys/ui/pages/pages.dart';

import './../helpers/helpers.dart';
import './../mocks/mocks.dart';

void main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    await tester
        .pumpWidget(makePage(path: '/login', page: () => LoginPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets(
    'Should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
      verify(() => presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(
          find.bySemanticsLabel(R.strings.password), password);
      verify(() => presenter.validatePassword(password));
    },
  );

  testWidgets(
    'Should present error if email is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitEmailError(UIError.invalidField);
      await tester.pump();

      expect(find.text(UIError.invalidField.description), findsOneWidget);
    },
  );

  testWidgets(
    'Should present error if email is empty',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitEmailError(UIError.requiredField);
      await tester.pump();

      expect(find.text(UIError.requiredField.description), findsOneWidget);
    },
  );

  testWidgets(
    'Should present no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitEmailValid();
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel(R.strings.email),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present error if password is empty',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitPasswordError(UIError.requiredField);
      await tester.pump();

      expect(find.text(UIError.requiredField.description), findsOneWidget);
    },
  );

  testWidgets(
    'Should present no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitPasswordValid();
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel(R.strings.password),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should enable button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitFormValid();
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(
        button.onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'Should disable button if form is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitFormError();
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(
        button.onPressed,
        null,
      );
    },
  );

  testWidgets(
    'Should call authentication on form submit',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitFormValid();
      await tester.pump();
      final button = find.byType(ElevatedButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();

      verify(() => presenter.auth()).called(1);
    },
  );

  testWidgets(
    'Should handle loading correctly',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitLoading();
      await tester.pump(Duration.zero);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      presenter.emitLoading(false);
      await tester.pump(Duration.zero);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);

      presenter.emitLoading();
      await tester.pump(Duration.zero);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should present error message if authentication fails',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitMainError(UIError.invalidCredentials);
      await tester.pump();

      expect(find.text(UIError.invalidCredentials.description), findsOneWidget);
    },
  );

  testWidgets(
    'Should present error message if authentication throws',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitMainError(UIError.unexpected);
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
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

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo(NavigationState(route: ''));
    await tester.pump();
    expect(currentRoute, '/login');
  });

  testWidgets(
    'Should go to goToSignUp on link click',
    (WidgetTester tester) async {
      await loadPage(tester);

      final button = find.text(R.strings.addAccount);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();

      verify(() => presenter.goToSignUp()).called(1);
    },
  );
}
