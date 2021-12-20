import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/auth/login_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final LoginService service = locator<LoginService>();

  Future<NetworkResponseModel> login(String email, String password) async{
    setBusy(true);
    final res = await  service.login(email, password);
    setBusy(false);
    return res;
  }
}
