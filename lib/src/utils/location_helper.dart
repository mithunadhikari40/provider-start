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
}