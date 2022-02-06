import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './../theme/theme.dart';

class Input extends StatelessWidget {
  final String? helperText;
  final Color? helperColor;
  final String? hintText;
  final Color? hintColor;
  final TextInputType? keyboardType;
  final void Function(String)? onChangedFunction;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final String? errorText;
  final Color? errorColor;
  final Widget? suffix;
  final Widget? prefix;
  final List<TextInputFormatter>? textInputFormatterList;
  final int? errorMaxLines;
  final double? height;
  final double? width;
  final TextAlign textAlign;
  final String? initialValue;
  final TextEditingController? textEditingController;
  final BoxConstraints? prefixIconConstraints;
  final bool? enabled;
  final bool? obscureText;

  Input({
    this.helperText,
    this.helperColor,
    this.hintText,
    this.keyboardType,
    this.onChangedFunction,
    this.enabledBorderColor = colorFunctionalHeavyLightest,
    this.focusedBorderColor = colorBrandPrimaryDark,
    this.errorBorderColor = colorFeedbackDangerDark,
    this.errorText,
    this.errorColor = colorFeedbackDangerDark,
    this.hintColor = colorFunctionalSoftDark,
    this.suffix,
    this.prefix,
    this.textInputFormatterList,
    this.errorMaxLines,
    this.height,
    this.width,
    this.textAlign = TextAlign.left,
    this.initialValue,
    this.textEditingController,
    this.prefixIconConstraints,
    this.enabled,
    this.obscureText,
  });

  Widget get defaultInput {
    var enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: enabledBorderColor, width: 2.0),
    );

    var errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: errorBorderColor, width: 2.0),
    );

    var errorTextStyle = TextStyle(
      color: errorColor,
      fontSize: fontSizeXXXXS,
    );
    var helperTextStyle = TextStyle(
      color: helperColor,
      fontSize: fontSizeXXXXS,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: width,
          child: TextFormField(
            obscureText: obscureText ?? false,
            enabled: enabled,
            initialValue: initialValue,
            controller: textEditingController,
            cursorColor: focusedBorderColor,
            textAlign: textAlign,
            decoration: InputDecoration(
              prefixIcon: prefix,
              prefixIconConstraints: prefixIconConstraints,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              suffix: suffix,
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor, fontSize: fontSizeXXS),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(),
              ),
              enabledBorder: enabledBorder,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
              ),
              errorBorder: errorText != null ? errorBorder : enabledBorder,
              errorMaxLines: errorMaxLines,
              errorText: errorText ?? helperText,
              errorStyle: errorText != null ? errorTextStyle : helperTextStyle,
            ),
            keyboardType: keyboardType,
            inputFormatters: textInputFormatterList,
            onChanged: onChangedFunction,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return defaultInput;
  }
}
