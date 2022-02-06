import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import './../../helpers/helpers.dart';
import './../../components/components.dart';
import './../../mixins/mixins.dart';

import './components/components.dart';
import './login.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      handleLoading(context: context, stream: widget.presenter.isLoadingStream);
      handleMainError(
          context: context, stream: widget.presenter.mainErrorStream);
      handleNavigation(stream: widget.presenter.navigateToStream);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => hideKeyboard(context),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: totalHeight,
              ),
              child: ListenableProvider(
                create: (_) => widget.presenter,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // LoginHeader(),
                      Headline1(
                        text: R.strings.welcomeBack,
                      ),
                      Container(
                        child: SvgPicture.asset(
                          LoginAssets.surveySvg,
                          //width: 100,
                          height: totalHeight * 0.3,
                        ),
                      ),
                      EmailInput(),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                          bottom: 32,
                        ),
                        child: PasswordInput(),
                      ),
                      LoginButton(
                        buttonWidth: totalWidth,
                      ),
                      SignUpField(
                        onTap: widget.presenter.goToSignUp,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
