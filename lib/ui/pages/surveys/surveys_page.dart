import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../components/components.dart';
import './../../helpers/helpers.dart';
import './../../mixins/mixins.dart';

import './components/components.dart';
import './surveys.dart';

class SurveysPage extends StatelessWidget
    with LoadingManager, NavigationManager, SessionManager {
  final SurveysPresenter presenter;

  SurveysPage({
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.logout,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context: context, stream: presenter.isLoadingStream);
          handleSessionExpired(stream: presenter.isSessionExpiredStream);
          handleNavigation(stream: presenter.navigateToStream);

          presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
              stream: presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: '${snapshot.error}',
                    reload: presenter.loadData,
                  );
                }

                if (snapshot.hasData) {
                  return ListenableProvider(
                    create: (_) => presenter,
                    child: SurveyItems(
                      viewModels: snapshot.data!,
                    ),
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
