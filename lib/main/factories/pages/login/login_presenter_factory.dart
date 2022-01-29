import './../../../../presentation/presenters/presenters.dart';
import './../../../../ui/pages/pages.dart';

import './../../../factories/factories.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    authentication: makeFirebaseRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
