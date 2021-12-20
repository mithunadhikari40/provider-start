import 'package:flutter/material.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/core/navigation/route_paths.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/services/rx_data_service.dart';
import 'package:places/src/viewmodels/dashboard/explore_view_model.dart';
import 'package:places/src/widgets/dashboard/place_item.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/loading_indicator.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: locator<ExploreViewModel>(),
      builder: (BuildContext context, ExploreViewModel model, Widget? child) {
        return _buildAllPlaces(context, model);
      },
      onModelReady: _onModelReady,
    );
  }

  void _onModelReady(ExploreViewModel model) {
    model.getAllPlaces();
  }

  Widget _buildAllPlaces(BuildContext context, ExploreViewModel model) {
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
    return StreamBuilder<List<PlaceModel>>(
        stream: model.allPlacesStream,
        builder: (context, AsyncSnapshot<List<PlaceModel>> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return ErrorView(
                messages: "No places found",
                callback: () {
                  _onModelReady(model);
                });
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return PlaceItem(
                place: snapshot.data![index],
                location: locator<RxDataService>().currentLocation,
                onTap: (place) {
                  Navigator.of(context)
                      .pushNamed(RoutePaths.PLACE_DETAIL, arguments: place);
                },
              );
            },
          );
        });
  }
}
