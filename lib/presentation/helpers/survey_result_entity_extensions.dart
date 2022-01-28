import '../../domain/domain.dart';

import '../../ui/pages/pages.dart';

extension SurveyResultEntityExtesions on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
        surveyId: surveyId,
        question: question,
        answers: answers
            .map(
              (answer) => answer.toViewModel(),
            )
            .toList(),
      );
}

extension SurveyAnswerEntityExtesions on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: '$percent%',
      );
}
