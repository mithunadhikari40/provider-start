import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/services/dashboard/explore_service.dart';

class ExploreViewModel extends BaseViewModel{
  final ExploreService service;

  ExploreViewModel({required this.service});

  List<PlaceModel> get places => service.places;
  String? get errorMessage  => service.errorMessage;

  Future<void> initialize() async{
    setBusy(true);
    await service.getAllPlaces();
    setBusy(false);
  }

}