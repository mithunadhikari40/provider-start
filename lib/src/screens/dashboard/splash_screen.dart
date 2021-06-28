import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/screens/dashboard/dashboard_screen.dart';
import 'package:places/src/screens/auth/login_screen.dart';
import 'package:places/src/viewmodels/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SplashViewModel>(
        model: SplashViewModel(service: Provider.of(context)),
        onModelReady: (model) => _onModelReady(model, context),
        builder: (context, SplashViewModel model, child) {
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  Future<void> _onModelReady(
      SplashViewModel model, BuildContext context) async {
    await model.initialize();
    bool isLoggedIn = model.isLoggedIn;

    //wait for 1500ms
    await Future.delayed(Duration(milliseconds: 1500));
    // navigate to LoginScreen if isLoggedIn == false else to DashboardScreen
    Widget? screen;
    if (isLoggedIn) {
      screen = DashboardScreen();
    } else {
      screen = LoginScreen();
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => screen!));
  }
}
