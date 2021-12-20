import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/services/dashboard/favorite_service.dart';
import 'package:places/src/viewmodels/base_view_model.dart';

class AddToFavoriteViewModel extends BaseViewModel {
  final FavoriteService service = locator<FavoriteService>();

  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  Future<void> isFavoritePlace(String placeId) async {
    final response = await service.isFavorite(placeId);
    _isFavorite = response.status;
    notifyListeners();
  }

  Future<void> addOrRemoveFromFavorite(String placeId) async {
    print("Id we sending $placeId");
    _isFavorite = !_isFavorite;
    service.addOrRemoveFromFavorite(placeId);
    notifyListeners();
  }
}
