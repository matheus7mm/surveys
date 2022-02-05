import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';

import './components/components.dart';
import './survey_result.dart';

class SurveyResultPage extends StatefulWidget {
  final SurveyResultPresenter presenter;

  SurveyResultPage({
    required this.presenter,
  });

  @override
  State<SurveyResultPage> createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage>
    with LoadingManager, SessionManager {
  @override
  void dispose() {
    widget.presenter.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      handleLoading(context: context, stream: widget.presenter.isLoadingStream);
      handleSessionExpired(stream: widget.presenter.isSessionExpiredStream);

      widget.presenter.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: StreamBuilder<SurveyResultViewModel?>(
        stream: widget.presenter.surveyResultStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ReloadScreen(
              error: '${snapshot.error}',
              reload: widget.presenter.loadData,
            );
          }

          if (snapshot.hasData) {
            return SurveyResult(
              viewModel: snapshot.data!,
              onSave: widget.presenter.save,
            );
          }

          return SizedBox(
            height: 0,
          );
        },
      ),
    );
  }
}
