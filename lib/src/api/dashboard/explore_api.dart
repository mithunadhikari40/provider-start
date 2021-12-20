import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:places/src/core/authenticated_request.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/model/network_response_model.dart';

class ExploreApi {
  Future<NetworkResponseModel> getAllPlaces() async {
    try {
      final uri = Uri.parse(AppUrl.PLACES_LIST_URL);
      final response = await authenticatedRequest.get(uri);
      final body = jsonDecode(response.body);
      print("list of places $body");
      final list = PlaceModel.allResponse(body);
      return NetworkResponseModel(status: true, data: list);
    } catch (e) {
      print("The places exception $e");
      // "Exception:type int cannot be cast to type List";
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }

  Future<NetworkResponseModel> addNewPlace(
      String name,
      String monument,
      String description,
      String? imagePath,
      double latitude,
      double longitude,
      String? city,
      String streetAddress,
      String? street) async {
    try {
      final uri = Uri.parse(AppUrl.PLACES_URL);

      MultipartRequest request = MultipartRequest('POST', uri);
      request.fields.addAll({
        "name": name,
        "city": city!,
        "street": street!,
        "monument": monument,
        "address": streetAddress,
        "description": description,
        "latitude": "$latitude",
        "longitude": "$longitude",
      });

      request.headers.addAll({
        "Content-Type":"multipart/form-data",
      });

      final imageBody = await MultipartFile.fromPath("image", imagePath!,
          contentType: MediaType("image", "jpg"));
      request.files.add(imageBody);
      final streamedResponse = await authenticatedRequest.send(request);
      final response = await Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      print("create place response $body");
      final place = PlaceModel.fromJson(body["place"]);
      return NetworkResponseModel(status: true, data: place);
    } catch (e) {
      print("Add new place error $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }
}
