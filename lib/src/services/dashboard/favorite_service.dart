import 'package:location/location.dart';
import 'package:places/src/api/dashboard/explore_api.dart';
import 'package:places/src/api/dashboard/favorite_api.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/auth_rx_provider.dart';

class FavoriteService {
  final FavoriteApi api;
  final AuthRxProvider authRxProvider;

  FavoriteService({required this.api, required this.authRxProvider});

  NetworkResponseModel? _places;

  NetworkResponseModel get places => _places!;

  LocationData? get currentLocation => authRxProvider.getLocation;

  Future<void> getAllPlaces() async {
    String token = authRxProvider.getToken!;
    final response = await api.getAllPlaces(token);
    _places = response;
  }

  void removeItem(int index) {
    List<PlaceModel> list =  _places!.data!.cast<PlaceModel>();
    list.removeAt(index);
    _places!.data = list;
  }
}
