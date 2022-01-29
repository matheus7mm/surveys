import 'package:get/state_manager.dart';

import './../../domain/domain.dart';
import './../../ui/pages/splash/splash.dart';

import './../mixins/mixins.dart';

class GetxSplashPresenter extends GetxController
    with NavigationManager
    implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(
      Duration(
        seconds: durationInSeconds,
      ),
    );
    try {
      // await Firebase.initializeApp();
      await loadCurrentAccount.load();
      navigateTo = NavigationState(route: '/surveys');
    } catch (error) {
      navigateTo = NavigationState(route: '/login');
    }
  }
}
