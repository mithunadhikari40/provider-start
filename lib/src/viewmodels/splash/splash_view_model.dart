import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/services/splash/splash_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class SplashViewModel extends BaseViewModel {
  final SplashService service = locator<SplashService>();

  bool get isAlreadyLoggedIn => service.isAlreadyLoggedIn;

  Future initialize() async {
    await service.initialize();
  }
}
