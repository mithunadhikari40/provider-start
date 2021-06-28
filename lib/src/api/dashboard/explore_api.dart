import 'dart:convert';

import 'package:http/http.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/dashboard/place_model.dart';

class ExploreApi {
  Future<List<PlaceModel>> getAllPlaces() async {
    try {
      final uri = Uri.parse(AppUrl.PLACES_LIST_URL);
      final response = await get(uri);
      final body = jsonDecode(response.body);
      print("list of places $body");
      return PlaceModel.allResponse(body);
    } catch (e) {
      print("The places exception $e");
      throw Exception("$e");
    }
  }
}
