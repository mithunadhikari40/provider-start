import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final bool readOnly;
  final LatLng currentLocation;
  final Function(LatLng)? onLocationSelected;

  const MapView({
    Key? key,
    required this.currentLocation,
    this.readOnly = false,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late LatLng _currentLocation = widget.currentLocation;
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: _currentLocation, zoom: 14.5),
      compassEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) {
        this._controller = controller;
      },
      markers: {
        Marker(
            markerId: MarkerId("daf"),
            position: _currentLocation,
            infoWindow: InfoWindow(snippet: "You are here"))
      },
      onTap: (location) {
        setState(() {
          _currentLocation = location;
        });
        _controller!.animateCamera(CameraUpdate.newLatLng(_currentLocation));
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.readOnly ? "View on Map" : "Choose from Map",
      ),
      // textTheme: TextTheme(headline6: TextStyle(color: blackColor87,fontSize: 18)),
      actions: [
        IconButton(
          onPressed: () {
            if (widget.onLocationSelected != null) {
              widget.onLocationSelected!(_currentLocation);
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.check_circle),
        )
      ],
    );
  }
}
