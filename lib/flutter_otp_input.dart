import 'package:flutter/material.dart';

/// A widget that displays an OTP input field, with a verification button and a resend link.
///
/// The widget allows customization of the OTP input field, verification button, title, and resend functionality.
///
/// [length] specifies the number of OTP input fields. [onCompleted] is called when the OTP input is completed.
/// [onChanged] is called when the OTP value changes.
/// [borderColor] and [borderFieldColor] define the border colors for the OTP fields.
/// [backgroundColor] defines the background color of the OTP input fields.
/// [fieldWidth] and [borderRadius] define the width and border radius of each OTP input field.
/// [textStyle] defines the text style used in the OTP input fields.
/// [title] and [subtitle] provide the main title and description for the OTP verification.
/// [verifyText] is the text displayed on the verification button.
/// [resendText] is the text displayed for the resend option.
/// [verifyButtonColor] defines the background color of the verify button.
/// [errorMessage] is the error message displayed if the OTP input is invalid.
/// [onResend] is a callback function triggered when the resend option is tapped.
///
/// Example usage:
/// ```dart
/// OTPInput(
///   length: 6,
///   onCompleted: (otp) => print("OTP completé : $otp"),
///   phoneNumber: "+1234567890",
///   verifyText: "Verify",
///   resendMessage: "Didn’t receive code? ",
///   resendText: "Resend",
///   resendTextStyle: TextStyle(
///     color: Colors.blue,
///     fontSize: 16,
///     fontWeight: FontWeight.bold,
///     decoration: TextDecoration.underline,
///   ),
/// );
/// ```
class OTPInput extends StatefulWidget {
  /// The number of OTP input fields.
  final int length;

  /// Callback that is called when the OTP input is completed.
  final ValueChanged<String> onCompleted;

  /// Callback that is called when the OTP value changes.
  final ValueChanged<String>? onChanged;

  /// The border color of the OTP input fields.
  final Color borderColor;

  /// The color of the OTP field's border when not focused.
  final Color borderFieldColor;

  /// The background color of the OTP input fields.
  final Color backgroundColor;

  /// The width of each OTP input field.
  final double fieldWidth;

  /// The border radius for each OTP input field.
  final double borderRadius;

  /// The text style for the OTP input fields.
  final TextStyle textStyle;

  /// The main title text above the OTP input fields.
  final String title;

  /// The subtitle text below the title, describing the OTP input process.
  final String subtitle;

  /// The message shown before the resend text.
  final String resendMessage;

  /// The style of the title text.
  final TextStyle titleStyle;

  /// The style of the subtitle text.
  final TextStyle subtitleStyle;

  /// The style of the resend text.
  final TextStyle resendStyle;

  /// The custom style for the resend text link.
  final TextStyle resendTextStyle;

  /// The phone number associated with OTP verification.
  final String phoneNumber;

  /// The text displayed on the verify button.
  final String verifyText;

  /// The text displayed for the resend button.
  final String resendText;

  /// The background color for the verify button.
  final Color verifyButtonColor;

  /// The error message shown when OTP input is invalid.
  final String errorMessage;

  /// A callback function triggered when the resend option is tapped.
  final VoidCallback? onResend;

  const OTPInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.borderColor = const Color(0xFFE5A048),
    this.borderFieldColor = const Color(0xFF000000),
    this.backgroundColor = Colors.white,
    this.fieldWidth = 50,
    this.borderRadius = 12.0,
    required this.phoneNumber,
    this.verifyText = "Verify",
    this.resendText = "Resend",
    this.verifyButtonColor = const Color(0xFFE5A048),
    this.textStyle = const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    this.title = "OTP Verification",
    this.subtitle = "Enter the verification code we just sent to your number",
    this.resendMessage = "Didn’t receive code? ",
    this.titleStyle = const TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    this.subtitleStyle = const TextStyle(fontSize: 16, color: Colors.grey),
    this.resendStyle = const TextStyle(
        fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold),
    this.resendTextStyle = const TextStyle(
        fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
    this.errorMessage = "Please fill in all fields.",
    this.onResend,
  });

  @override
  _OTPInputState createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Called when the OTP input changes.
  /// This function triggers the [onChanged] callback with the current OTP.
  /// If the OTP is complete (matches [length]), it calls the [onCompleted] callback.
  void _onChanged() {
    String currentText = _controllers.map((c) => c.text).join();
    if (widget.onChanged != null) {
      widget.onChanged!(currentText);
    }
    if (currentText.length == widget.length) {
      widget.onCompleted(currentText);
    }
  }

  /// Verifies the OTP code.
  /// If the OTP code is valid, it calls the [onCompleted] callback, otherwise,
  /// it shows an error message.
  void _verifyCode() {
    String otpCode = _controllers.map((c) => c.text).join();
    if (otpCode.isEmpty || otpCode.length < widget.length) {
      setState(() {
        _errorMessage = widget.errorMessage;
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
      widget.onCompleted(otpCode);
    }
  }

  /// Called when the resend button is tapped.
  /// This function calls the [onResend] callback if provided.
  void _onResend() {
    if (widget.onResend != null) {
      widget.onResend!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: Text(
            widget.title,
            style: widget.titleStyle,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            "${widget.subtitle} ${widget.phoneNumber}",
            style: widget.subtitleStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: widget.fieldWidth,
              height: widget.fieldWidth,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: widget.borderFieldColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(1),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                style: widget.textStyle.copyWith(color: Colors.black),
                onChanged: (value) {
                  if (value.isNotEmpty && index < widget.length - 1) {
                    _focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  _onChanged();
                },
              ),
            );
          }),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ElevatedButton(
            onPressed: _verifyCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.verifyButtonColor,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
            ),
            child: Text(
              widget.verifyText,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _onResend,
          child: RichText(
            text: TextSpan(
              text: widget.resendMessage,
              style: widget.resendStyle,
              children: [
                TextSpan(
                  text: widget.resendText,
                  style: widget.resendTextStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
