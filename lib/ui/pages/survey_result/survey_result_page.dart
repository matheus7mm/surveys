import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';

import './components/components.dart';
import './survey_result.dart';

class SurveyResultPage extends StatelessWidget
    with LoadingManager, SessionManager {
  final SurveyResultPresenter presenter;

  SurveyResultPage({
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context: context, stream: presenter.isLoadingStream);
          handleSessionExpired(stream: presenter.isSessionExpiredStream);

          presenter.loadData();

          return StreamBuilder<SurveyResultViewModel?>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: '${snapshot.error}',
                    reload: presenter.loadData,
                  );
                }

                if (snapshot.hasData) {
                  return SurveyResult(
                    viewModel: snapshot.data!,
                    onSave: presenter.save,
                  );
                }

                return SizedBox(
                  height: 0,
                );
              });
        },
      ),
    );
  }
}
