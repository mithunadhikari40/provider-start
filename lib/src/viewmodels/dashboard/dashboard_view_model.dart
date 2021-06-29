import 'package:location/location.dart';
import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/services/dashboard/dashboard_service.dart';

class DashboardViewModel extends BaseViewModel {
  final DashboardService service;

  DashboardViewModel({required this.service});

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  String getAppbarTitle(){
    return ["Explore","Favorite","Profile"][_currentIndex];
  }

  void setLocation(LocationData locationData){
    service.setLocation(locationData);
  }
}
