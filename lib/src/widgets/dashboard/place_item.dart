import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/utils/image_helper.dart';
import 'package:places/src/utils/location_helper.dart';

class PlaceItem extends StatelessWidget {
  final PlaceModel place;
  final Function(PlaceModel model) onTap;

  final LocationData? location;
  const PlaceItem({Key? key, required this.place, required this.onTap, this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(place);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  child: Hero(
                    child: Image.network(getImage(place.image!)),
                    tag: Key(place.sId!),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                SizedBox(height: 8),
                Text("${place.name}",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6),
                SizedBox(height: 8),
                Text("Near: ${place.monument}"),
                SizedBox(height: 8),
                location == null
                    ? Text("Some distance away")
                    : Text(
                    "${LocationHelper.calculateDistanceInKm(latitude1: location!.latitude!, longitude1: location!.longitude!, latitude2: place.latitude!, longitude2: place.longitude!).toStringAsFixed(1)} KM"),
                SizedBox(height: 8),
                location == null
                    ? Text("Few moments away")
                    : Text(
                    "${LocationHelper.getApproximateTravelTime(latitude1: location!.latitude!, longitude1: location!.longitude!, latitude2: place.latitude!, longitude2: place.longitude!)}"),
                SizedBox(height: 8),
                Text("${place.description}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}