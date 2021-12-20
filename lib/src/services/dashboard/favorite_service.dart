import 'package:places/src/api/dashboard/favorite_api.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';

class FavoriteService {
  final FavoriteApi api = locator<FavoriteApi>();

  List<PlaceModel> _allPlaces = [];

  List<PlaceModel> get allPlaces => List.from(_allPlaces);

  Future<void> getAllPlaces() async {
    final response = await api.getAllPlaces();
    if (response.status) {
      _allPlaces = response.data.cast<PlaceModel>();
    }
  }

  Future<NetworkResponseModel> removePlace(int index, PlaceModel place) async {
    final response = await api.addOrRemoveFromFavorite(place.sId!);
    if (response.status) {
      _allPlaces.removeAt(index);
    }
    return response;
  }

  Future<NetworkResponseModel> addOrRemoveFromFavorite(String id) async {
    return api.addOrRemoveFromFavorite(id);
  }

  Future<NetworkResponseModel> isFavorite(String id) async {
    return await api.isFavorite(id);
  }
}
