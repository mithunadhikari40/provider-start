import 'package:geocoding/geocoding.dart';
import 'package:places/src/api/dashboard/explore_api.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:rxdart/rxdart.dart';

class ExploreService {
  final ExploreApi api = locator<ExploreApi>();

  final CacheProvider cacheProvider = locator<CacheProvider>();

  List<PlaceModel> _allPlaces = [];

  List<PlaceModel> get allPlaces =>
      _placeListSubject.hasValue ? _placeListSubject.value : [];

  final BehaviorSubject<List<PlaceModel>> _placeListSubject = BehaviorSubject();
  Stream<List<PlaceModel>> get allPlaceStream => _placeListSubject.stream;

  void close() {
    _placeListSubject.close();
  }

  Future<void> getAllPlaces() async {
    final NetworkResponseModel response = await api.getAllPlaces();
    if (response.status) {
      _allPlaces = response.data.cast<PlaceModel>();
      _placeListSubject.sink.add(_allPlaces);
    }
  }

  Future<NetworkResponseModel> submitData(
      String name,
      String monument,
      String description,
      String? imagePath,
      double? latitude,
      double? longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);
      if (placemarks.isEmpty) {
        return NetworkResponseModel(
            status: false,
            message: "Could not retrieve place info, please try again");
      }
      final place = placemarks.first;
      final streetAddress =
          "${place.name}, ${place.subLocality}, ${place.locality}";
      final city = place.locality;
      final street = place.street;
      print("Street address $streetAddress, $city");

      final response = await api.addNewPlace(
        name,
        monument,
        description,
        imagePath,
        latitude,
        longitude,
        city,
        streetAddress,
        street,
      );
      if (response.status) {
        final PlaceModel place = response.data as PlaceModel;
        _allPlaces.add(place);
        _placeListSubject.sink.add(_allPlaces);
      }
      return response;
    } catch (e) {
      print("Errror $e");
      return NetworkResponseModel(
          status: false,
          message: "Could not retrieve place info, please try again");
    }
  }
}
