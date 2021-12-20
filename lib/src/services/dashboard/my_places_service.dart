import 'package:places/src/api/dashboard/my_places_api.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/rx_data_service.dart';

class MyPlacesService {
  final MyPlacesApi api = locator<MyPlacesApi>();
  final RxDataService rxDataService = locator<RxDataService>();

  List<PlaceModel> _allPlaces = [];

  List<PlaceModel> get allPlaces => List.from(_allPlaces);

  Future<void> getAllPlaces() async {
    final response = await api.getAllPlaces();
    if (response.status) {
      _allPlaces = response.data.cast<PlaceModel>();
    }
  }

  Future<NetworkResponseModel> removeItem(
      String placeId, PlaceModel place) async {
    final response = await api.deletePlace(placeId);
    if (response.status) {
      _allPlaces.removeWhere((element) => element.sId == placeId);
    }
    return response;
  }

  void removeForNow(String placeId) {
    _allPlaces.removeWhere((element) => element.sId == placeId);
  }
}
