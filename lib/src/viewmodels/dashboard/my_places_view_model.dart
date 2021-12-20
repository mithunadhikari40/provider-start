import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/dashboard/my_places_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class MyPlacesViewModel extends BaseViewModel {
  final MyPlacesService service = locator<MyPlacesService>();

  List<PlaceModel> get allPlaces => service.allPlaces;

  Future<void> initialize() async {
    setBusy(true);
    await service.getAllPlaces();
    setBusy(false);
  }

  Future<NetworkResponseModel> removePlace(String placeId, PlaceModel place) {
    service.removeForNow(placeId);
    notifyListeners();
    return service.removeItem(placeId, place);
  }
}
