import 'package:firebase_core/firebase_core.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../factories.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(
      loadCurrentAccount: makeLocalLoadCurrentAccount(),
      initFirebase: () async {
        await Firebase.initializeApp();
      });
}
