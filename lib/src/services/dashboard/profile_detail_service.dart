import 'package:places/src/api/dashboard/profile_api.dart';
import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/model/user_model.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';
import 'package:places/src/services/rx_data_service.dart';

class ProfileDetailService {
  final ProfileApi api = locator<ProfileApi>();
  final DbProvider dbProvider = locator<DbProvider>();
  final CacheProvider cacheProvider = locator<CacheProvider>();
  final RxDataService rxDataService = locator<RxDataService>();

  UserModel? get currentUser => rxDataService.currentUser;

  Future<bool> logout() async {
    // call an api to clear out the session data, or some other info
    await dbProvider.clear();
    await cacheProvider.clear();
    rxDataService.clear();
    return true;
  }

  Future<NetworkResponseModel> updateName(String newName) async {
    final response = await api.updateName(newName);
    if (response.status) {
      UserModel user = response.data!;
      rxDataService.addUser(user);
      await dbProvider.insertUser(user);
    }
    return response;
  }

  Future<NetworkResponseModel> updateProfilePic(
      String imagePth, String url) async {
    final response = await api.updateProfilePic(imagePth, url);
    if (response.status) {
      UserModel newUser = response.data!;
      rxDataService.addUser(newUser);
      await dbProvider.insertUser(newUser);
    }
    return response;
  }

  Future<NetworkResponseModel> updatePassword(String newPassword) async {
    final response = await api.updatePassword(newPassword);
    if (response.status) {
      rxDataService.addToken(response.data!);
      await cacheProvider.setStringValue(TOKEN_KEY, response.data!);
    }
    return response;
  }

  void pushTokenToServer(String? fcmToken) {
    api.updateToken(fcmToken!);
  }
}
