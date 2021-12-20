import 'dart:convert';

import 'package:places/src/core/authenticated_request.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';

class MyPlacesApi {
  Future<NetworkResponseModel> getAllPlaces() async {
    try {
      final uri = Uri.parse(AppUrl.PLACES_URL);
      final response = await authenticatedRequest.get(uri);
      final body = jsonDecode(response.body);
      print("list of my $body");

      final list = PlaceModel.allResponse(body);
      return NetworkResponseModel(status: true, data: list);
    } catch (e) {
      print("The my exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }

  Future<NetworkResponseModel> deletePlace(String placeId) async {
    try {
      final uri = Uri.parse("${AppUrl.PLACES_URL}/$placeId");
      final response = await authenticatedRequest.delete(uri);
      final body = jsonDecode(response.body);
      print("add or remove of favorite $body");
      if (body["_id"] == null) {
        return NetworkResponseModel(status: false);
      }
      return NetworkResponseModel(status: true);
    } catch (e) {
      print("The favorite add or remove exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }
}

// https://codelabs.developers.google.com/codelabs/admob-ads-in-flutter#0
