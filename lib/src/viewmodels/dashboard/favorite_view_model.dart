import 'package:location/location.dart';
import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/dashboard/favorite_service.dart';

class FavoriteViewModel extends BaseViewModel {
  final FavoriteService service;

  FavoriteViewModel({required this.service});

  LocationData? get currentLocation => service.currentLocation;

  NetworkResponseModel get places => service.places;

  Future<void> initialize() async {
    setBusy(true);
    await service.getAllPlaces();
    setBusy(false);
  }

  void removeItem(PlaceModel place) {
    List<PlaceModel> list =  service.places.data!.cast<PlaceModel>();
    int index = list.indexWhere((element) => element.sId == place.sId);
    // it just removes the item from the service
    service.removeItem(index);
    notifyListeners();
    // removes from api and returns the response
    // await service.removeFromApi(index,place);
    // notifyListeners();


  }
}
