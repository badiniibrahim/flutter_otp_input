import 'package:flutter/material.dart';
import 'package:flutter_otp_input/flutter_otp_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: OTPInput(
        length: 6,
        onCompleted: (value) => print('OTP Completed: $value'),
        onChanged: (value) => print('OTP Changed: $value'),
        textStyle: const TextStyle(fontSize: 18, color: Colors.black),
        borderFieldColor: Colors.blue,
        phoneNumber: "+33767567658",
        resendStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        onResend: () {
          print("Renvoi du code...");
        },
        verifyButtonColor: Colors.blue,
        errorMessage: "Code OTP invalide",
        resendTextStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
