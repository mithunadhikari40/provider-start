import 'package:places/src/api/auth_api.dart';

class LoginService{
  final api = AuthApi();
  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<bool> login(String email,String password) async {
    try {
      String token = await api.login(email, password);
      _errorMessage = "";
      return true;
      // fetch user profile, save in our local database, save token in local cache,
    }catch(e){
      _errorMessage = "$e".replaceAll("Exception:", "");
      return false;
    }
  }

}