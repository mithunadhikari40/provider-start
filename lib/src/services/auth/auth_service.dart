import 'package:places/src/api/auth_api.dart';
import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/model/user_model.dart';
import 'package:places/src/services/auth_rx_provider.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';

class AuthService {
  final AuthApi api;
  final DbProvider dbProvider;
  final CacheProvider cacheProvider;
  final AuthRxProvider authRxProvider;

  AuthService({
    required this.api,
    required this.dbProvider,
    required this.authRxProvider,
    required this.cacheProvider,
  });

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    try {
      String token = await api.login(email, password);
      // fetch user profile, save in our local database, save token in local cache,
      return fetchUserDetail(token);
    } catch (e) {
      _errorMessage = "$e".replaceAll("Exception:", "");
      return false;
    }
  }
  Future<bool> signup(String name, String phone,String email, String password) async {
    try {
      String token = await api.register(name,phone,email, password);
      // fetch user profile, save in our local database, save token in local cache,
      return fetchUserDetail(token);
    } catch (e) {
      _errorMessage = "$e".replaceAll("Exception:", "");
      return false;
    }
  }

  Future<bool> fetchUserDetail(String token) async {
    try {
      UserModel user = await api.fetchUserDetail(token);
      await dbProvider.insertUser(user);
      await cacheProvider.setStringValue(TOKEN_KEY, token);
      authRxProvider.addToken(token);
      authRxProvider.addUser(user);
      // store the user in the local db
      //store the token in the cache..
      return true;
    } catch (e) {
      _errorMessage = "$e".replaceAll("Exception:", "");
      return false;
    }
  }
}
