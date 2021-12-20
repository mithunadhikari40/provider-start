import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/core/navigation/route_paths.dart';
import 'package:places/src/viewmodels/splash/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseWidget<SplashViewModel>(
        model: locator<SplashViewModel>(),
        onModelReady: (model){
          _onModelReady(model,context);
        },
        builder: (BuildContext context, SplashViewModel model, Widget? child){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/splash_image.jpg"),
                fit: BoxFit.cover
              )
            ),
          );
        },
      ),
    );
  }

  Future<void> _onModelReady(SplashViewModel model, BuildContext context) async{
    await model.initialize();
    String path = RoutePaths.LOGIN;
    if(model.isAlreadyLoggedIn){
      path = RoutePaths.DASHBOARD;
    }
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pushReplacementNamed(path);

    // Timer(Duration(seconds: 2),() {
    //   Navigator.of(context).pushReplacementNamed(path);
    // });

  }
}
