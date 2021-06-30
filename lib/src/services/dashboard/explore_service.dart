import 'package:location/location.dart';
import 'package:places/src/api/dashboard/explore_api.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/auth_rx_provider.dart';

class ExploreService {
  final ExploreApi api;
  final AuthRxProvider authRxProvider;

  ExploreService({required this.api, required this.authRxProvider});

  NetworkResponseModel? _places;

  NetworkResponseModel get places => _places!;

  LocationData? get currentLocation => authRxProvider.getLocation;

  Future<void> getAllPlaces() async {
    final response = await api.getAllPlaces();
    // if(response.status){
    //   //to something
    //   String value  = response.data;
    // }
    _places = response;
  }
}
