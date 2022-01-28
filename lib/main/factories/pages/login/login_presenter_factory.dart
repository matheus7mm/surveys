import './../../../../presentation/presenters/presenters.dart';
import './../../../../ui/pages/pages.dart';

import './../../../factories/factories.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
