import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/model/user_model.dart';
import 'package:places/src/services/dashboard/profile_detail_service.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/rx_data_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class ProfileDetailViewModel extends BaseViewModel {
  final ProfileDetailService service = locator<ProfileDetailService>();
  final RxDataService rxDataService = locator<RxDataService>();
  final CacheProvider cacheProvider = locator<CacheProvider>();

  UserModel? get currentUser => service.currentUser;

  Future<bool> logout() {
    return service.logout();
  }

  Future<NetworkResponseModel> updateName(String newName) async {
    var response = await service.updateName(newName);
    notifyListeners();
    return response;
  }

  Future<NetworkResponseModel> updatePassword(String newPassword) async {
    var response = await service.updatePassword(newPassword);
    return response;
  }

  Future<NetworkResponseModel> updateProfilePic(String path) async {
    var response =
        await service.updateProfilePic(path, AppUrl.UPDATE_PROFILE_PIC_URL);
    notifyListeners();
    return response;
  }

  Future<NetworkResponseModel> updateCoverPic(String path) async {
    var response =
        await service.updateProfilePic(path, AppUrl.UPDATE_COVER_PIC_URL);
    notifyListeners();
    return response;
  }

  void changeTheme(bool val) {
    rxDataService.addTheme(val);
    cacheProvider.setBoolValue(THEME_KEY, val);

    notifyListeners();
  }

  bool? get currentTheme => rxDataService.currentTheme;
}
