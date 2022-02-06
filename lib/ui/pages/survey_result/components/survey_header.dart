import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:surveys/ui/components/components.dart';

class SurveyHeader extends StatelessWidget {
  final String question;
  final bool didAnswer;

  SurveyHeader({required this.question, required this.didAnswer});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final totalHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom -
        mediaQuery.viewInsets.bottom;

    return Container(
      height: totalHeight * 0.3,
      padding: EdgeInsets.only(
        top: 40,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withAlpha(90),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.asset(
                (didAnswer == true)
                    ? SurveysAssets.didAnswerSvg
                    : SurveysAssets.didNotAnswerSvg,
              ),
              height: totalHeight * 0.2,
            ),
          ),
          Text(
            question,
            style: TextStyle(
              color: colorBrandPrimaryDarkest,
              fontSize: fontSizeSM,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
