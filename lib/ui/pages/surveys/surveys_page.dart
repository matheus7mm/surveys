import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../components/components.dart';
import './../../helpers/helpers.dart';
import './../../mixins/mixins.dart';

import './components/components.dart';
import './surveys.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage({
    required this.presenter,
  });

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, NavigationManager, SessionManager {
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
      handleNavigation(stream: widget.presenter.navigateToStream);

      widget.presenter.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: widget.presenter.signOut,
              child: Icon(
                Icons.logout,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<SurveyViewModel>>(
        stream: widget.presenter.surveysStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ReloadScreen(
              error: '${snapshot.error}',
              reload: widget.presenter.loadData,
            );
          }

          if (snapshot.hasData) {
            return ListenableProvider(
              create: (_) => widget.presenter,
              child: SurveyItems(
                viewModels: snapshot.data!,
              ),
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
