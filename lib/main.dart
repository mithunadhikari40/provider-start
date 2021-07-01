import 'package:flutter/material.dart';
import 'package:places/src/screens/auth/login_screen.dart';

Future<void> main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: "Places",
        theme: ThemeData.light(),
        home: LoginScreen(),
    );
  }
}
