import 'package:flutter/material.dart';

import './../survey_result.dart';

import './components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({required String answer}) onSave;

  SurveyResult({
    required this.viewModel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(
            question: viewModel.question,
            didAnswer:
                viewModel.answers.any((item) => item.isCurrentAnswer == true),
          );
        }

        final answer = viewModel.answers[index - 1];

        return GestureDetector(
          onTap: () =>
              answer.isCurrentAnswer ? null : onSave(answer: answer.answer),
          child: SurveyAnswer(
            viewModel: viewModel.answers[index - 1],
          ),
        );
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
