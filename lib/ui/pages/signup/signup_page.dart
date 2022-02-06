import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../components/components.dart';

import './components/components.dart';
import './signup.dart';

class SignUpPage extends StatefulWidget {
  final SignUpPresenter presenter;

  SignUpPage(this.presenter);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
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
    final mediaQuery = MediaQuery.of(context);

    final totalWidth = mediaQuery.size.width;
    final totalHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom -
        mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => hideKeyboard(context),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: mediaQuery.viewInsets.bottom == 0
                    ? totalHeight
                    : (mediaQuery.size.height - mediaQuery.viewInsets.bottom),
              ),
              child: ListenableProvider(
                create: (_) => widget.presenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Headline1(
                        text: R.strings.joinUs,
                      ),
                      if (mediaQuery.viewInsets.bottom == 0)
                        Flexible(
                          flex: 6,
                          child: Container(
                            width: totalWidth,
                            height: totalHeight * 0.3,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SvgPicture.asset(
                              LoginAssets.joinUsSvg,
                            ),
                          ),
                        ),
                      NameInput(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: EmailInput(),
                      ),
                      PasswordInput(),
                      Flexible(
                        child: SizedBox(
                          height: 32,
                        ),
                      ),
                      SignUpButton(
                        buttonWidth: totalWidth,
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      LoginField(
                        onTap: widget.presenter.goToLogin,
                      ),
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
