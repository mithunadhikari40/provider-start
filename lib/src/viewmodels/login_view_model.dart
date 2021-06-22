import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/services/auth/login_service.dart';

class LoginViewModel extends BaseViewModel {
  final loginService = LoginService();
  String get errorMessage => loginService.errorMessage;

  Future<bool> login(String email, String password) async {
    setBusy(true);
    final response = await loginService.login(email, password);
    setBusy(false);
    return response;
  }
}
