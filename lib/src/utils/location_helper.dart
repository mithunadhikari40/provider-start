import 'dart:math';

class LocationHelper{
  static double calculateDistanceInKm(
      {required double latitude1,
        required double longitude1,
        required double latitude2,
        required double longitude2}) {

    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((latitude2 - latitude1) * p) / 2 +
        cos(latitude1 * p) *
            cos(latitude2 * p) *
            (1 - cos((longitude2 - longitude1) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  static String getApproximateTravelTime(
      {required double latitude1,
        required double longitude1,
        required double latitude2,
        required double longitude2}) {


    double distance = calculateDistanceInKm(
        latitude1: latitude1,
        longitude1: longitude1,
        latitude2: latitude2,
        longitude2: longitude2) *
        1000;
    int minimum = (distance ~/ (60 * 20));
    if (minimum < 1) return "1 min";
    int maximum = (distance ~/ (60 * 10));
    if (minimum > 60 && maximum > 60) {
      minimum = minimum ~/ 60;
      maximum = maximum ~/ 60;
      return "$minimum-$maximum hr";
    }
    if (minimum < 60 && maximum > 60) {
      minimum = minimum ~/ 60;
      maximum = maximum ~/ 60;
      return "$minimum min-$maximum hr";
    }

    return "$minimum-$maximum min";
  }
}