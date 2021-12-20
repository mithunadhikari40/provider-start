import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/services/dashboard/profile_detail_service.dart';
import 'package:places/src/services/rx_data_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class DashboardViewModel extends BaseViewModel {
  final RxDataService rxDataService = locator<RxDataService>();
  final ProfileDetailService profileDetailService =
      locator<ProfileDetailService>();
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void addUserLocation(LocationData locationData) {
    rxDataService.addLocation(locationData);
  }

  void pushTokenToServer(String? fcmToken) {
    profileDetailService.pushTokenToServer(fcmToken);
  }
}
