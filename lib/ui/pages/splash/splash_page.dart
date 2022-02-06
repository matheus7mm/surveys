import 'package:flutter/material.dart';
import 'package:surveys/ui/components/theme/theme.dart';

import './../../mixins/mixins.dart';

import './splash.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  SplashPage({required this.presenter});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NavigationManager {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      handleNavigation(stream: widget.presenter.navigateToStream);

      widget.presenter.checkAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBrandPrimaryMedium,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
