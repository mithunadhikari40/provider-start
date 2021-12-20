import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/dashboard/expore_service.dart';
import 'package:places/src/services/rx_data_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class AddNewPlaceViewModel extends BaseViewModel {
  final ExploreService service = locator<ExploreService>();
  final RxDataService rxDataService = locator<RxDataService>();

  String? _imagePath;

  String? get imagePath => _imagePath;

  void setImage(String path) {
    _imagePath = path;
    notifyListeners();
  }

  LatLng? _location;

  LatLng? get location => _location;

  LatLng get userCurrentLocation => LatLng(
      rxDataService.currentLocation!.latitude!,
      rxDataService.currentLocation!.longitude!);

  void setUserCurrentLocation({LatLng? latLng}) {
    if (latLng != null) {
      _location = latLng;
    } else {
      LocationData loc = rxDataService.currentLocation!;
      _location = LatLng(loc.latitude!, loc.longitude!);
    }
    notifyListeners();
  }

  Future<NetworkResponseModel> submitData(
      String name, String monument, String description) async {
    setBusy(true);
    final response = await service.submitData(
      name,
      monument,
      description,
      _imagePath,
      _location?.latitude,
      _location?.longitude,
    );
    setBusy(false);
    return response;
  }
}
