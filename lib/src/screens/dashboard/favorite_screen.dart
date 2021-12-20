import 'package:flutter/material.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/core/navigation/route_paths.dart';
import 'package:places/src/services/rx_data_service.dart';
import 'package:places/src/viewmodels/dashboard/favorite_view_model.dart';
import 'package:places/src/widgets/dashboard/place_item.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/loading_indicator.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: locator<FavoriteViewModel>(),
      builder: (BuildContext context, FavoriteViewModel model, Widget? child) {
        return _buildAllPlaces(context, model);
      },
      onModelReady: _onModelReady,
    );
  }

  void _onModelReady(FavoriteViewModel model) {
    model.getAllPlaces();
  }

  Widget _buildAllPlaces(BuildContext context, FavoriteViewModel model) {
    if (model.busy) {
      return LoadingIndicator();
    }
    if (model.allPlaces.isEmpty) {
      return ErrorView(
          messages: "No places found",
          callback: () {
            _onModelReady(model);
          });
    }
    return ListView.builder(
      itemCount: model.allPlaces.length,
      itemBuilder: (BuildContext context, int index) {
        return PlaceItem(
          place: model.allPlaces[index],
          location: locator<RxDataService>().currentLocation,
          onTap: (place) {
            Navigator.of(context)
                .pushNamed(RoutePaths.PLACE_DETAIL, arguments: place);
          },
        );
      },
    );
  }
}
