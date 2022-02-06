import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../../components/components.dart';
import './../../pages.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel viewModel;

  SurveyItem(this.viewModel);

  final Color didAnswerColor = colorFunctionalSoftMedium;
  final Color didAnswerBoxShadowColor = colorFunctionalHeavyDarkest;

  final Color didNotAnswerColor = colorBrandPrimaryLight;
  final Color didNotAnswerBoxShadowColor = colorBrandPrimaryDarkest;

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SurveysPresenter>(context);
    return GestureDetector(
      onTap: () => presenter.goToSurveyResult(viewModel.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Container(
          padding: EdgeInsets.all(
            20,
          ),
          margin: EdgeInsets.all(
            5,
          ),
          decoration: BoxDecoration(
            color: viewModel.didAnswer ? didAnswerColor : didNotAnswerColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 0,
                blurRadius: 4,
                color: viewModel.didAnswer
                    ? didAnswerBoxShadowColor
                    : didNotAnswerBoxShadowColor,
              )
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Text(
                viewModel.date,
                style: TextStyle(
                  color: colorBrandPrimaryDarkest,
                  fontSize: fontSizeSM,
                  fontWeight: fontWeightBold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                viewModel.question,
                style: TextStyle(
                  color: colorBrandPrimaryDarkest,
                  fontSize: fontSizeMD,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
