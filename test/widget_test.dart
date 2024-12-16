import 'package:flutter/material.dart';
import 'package:flutter_otp_input/flutter_otp_input.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createOTPInputWidget({
  required Function(String) onCompleted,
  String title = "OTP Verification",
  String subtitle = "Enter the verification code we just sent to your number",
  String phoneNumber = "+1234567890",
}) {
  return MaterialApp(
    home: Scaffold(
      body: OTPInput(
        onCompleted: onCompleted,
        phoneNumber: phoneNumber,
        title: title,
        subtitle: subtitle,
      ),
    ),
  );
}

void main() {
  group('OTPInput Widget Tests', () {
    testWidgets('OTP Input should call onCompleted when OTP is completed',
        (WidgetTester tester) async {
      // Define a mock callback for onCompleted
      String otp = '';
      void onCompleted(String value) {
        otp = value;
      }

      // Create OTPInput widget
      await tester.pumpWidget(createOTPInputWidget(onCompleted: onCompleted));

      // Enter OTP (simulate entering each digit)
      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.enterText(find.byType(TextField).at(3), '4');
      await tester.enterText(find.byType(TextField).at(4), '5');
      await tester.enterText(find.byType(TextField).at(5), '6');

      // Wait for the widget to update
      await tester.pump();

      // Check that onCompleted was called with the correct OTP
      expect(otp, '123456');
    });

    testWidgets('Error message should appear when OTP is incomplete',
        (WidgetTester tester) async {
      await tester.pumpWidget(createOTPInputWidget(
        onCompleted: (value) {},
      ));

      // Leave the OTP fields incomplete
      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.pump();

      // Tap the verify button
      await tester.tap(find.text('Verify'));
      await tester.pump();

      // Check that the error message is displayed
      expect(find.text('Please fill in all fields.'), findsOneWidget);
    });

    testWidgets('Resend button should trigger onResend callback',
        (WidgetTester tester) async {
      bool resendTriggered = false;
      void onResend() {
        resendTriggered = true;
      }

      await tester.pumpWidget(createOTPInputWidget(
        onCompleted: (value) {},
      ));

      // Trigger resend
      await tester.tap(find.text('Resend'));
      await tester.pump();

      // Check that onResend was triggered
      expect(resendTriggered, true);
    });

    testWidgets('Verify button should be disabled with incomplete OTP',
        (WidgetTester tester) async {
      await tester.pumpWidget(createOTPInputWidget(
        onCompleted: (value) {},
      ));

      // Enter incomplete OTP
      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.pump();

      // Verify button should not be enabled
      final verifyButton = find.text('Verify');
      final verifyButtonWidget = tester.widget<ElevatedButton>(verifyButton);
      expect(verifyButtonWidget.enabled, isFalse);
    });

    testWidgets('Verify button should be enabled with complete OTP',
        (WidgetTester tester) async {
      await tester.pumpWidget(createOTPInputWidget(
        onCompleted: (value) {},
      ));

      // Enter complete OTP
      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.enterText(find.byType(TextField).at(3), '4');
      await tester.enterText(find.byType(TextField).at(4), '5');
      await tester.enterText(find.byType(TextField).at(5), '6');
      await tester.pump();

      // Verify button should be enabled
      final verifyButton = find.text('Verify');
      final verifyButtonWidget = tester.widget<ElevatedButton>(verifyButton);
      expect(verifyButtonWidget.enabled, isTrue);
    });

    testWidgets('Check if title and subtitle are displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createOTPInputWidget(
        onCompleted: (value) {},
        title: "Custom OTP Title",
        subtitle: "Custom OTP Subtitle",
      ));

      // Check title and subtitle text
      expect(find.text("Custom OTP Title"), findsOneWidget);
      expect(find.text("Custom OTP Subtitle"), findsOneWidget);
    });
  });
}
