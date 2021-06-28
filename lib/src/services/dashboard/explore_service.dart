import 'package:places/src/api/dashboard/explore_api.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/services/auth_rx_provider.dart';

class ExploreService {
  final ExploreApi api;
  final AuthRxProvider authRxProvider;

  ExploreService({required this.api, required this.authRxProvider});

  List<PlaceModel> _places = [];

  List<PlaceModel> get places => _places;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getAllPlaces() async {
    try {
      final response = await api.getAllPlaces();
      _places = response;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "$e".replaceAll("Exception:", "");
    }
  }
}
