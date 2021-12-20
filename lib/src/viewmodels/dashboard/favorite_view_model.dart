import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/dashboard/favorite_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class FavoriteViewModel extends BaseViewModel {
  final FavoriteService service = locator<FavoriteService>();

  List<PlaceModel> get allPlaces => service.allPlaces;

  Future<void> getAllPlaces() async {
    setBusy(true);
    await service.getAllPlaces();
    setBusy(false);
  }

  Future<NetworkResponseModel> removePlace(int index, PlaceModel place) async {
    return service.removePlace(index, place);
  }
}
