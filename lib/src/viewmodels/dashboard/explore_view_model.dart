import 'package:location/location.dart';
import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/dashboard/explore_service.dart';

class ExploreViewModel extends BaseViewModel {
  final ExploreService service;

  ExploreViewModel({required this.service});

  LocationData? get currentLocation => service.currentLocation;

  NetworkResponseModel get places => service.places;

  Future<void> initialize() async {
    setBusy(true);
    await service.getAllPlaces();
    setBusy(false);
  }
}
