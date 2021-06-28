import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/utils/image_helper.dart';
import 'package:places/src/viewmodels/dashboard/explore_view_model.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ExploreViewModel>(
        model: ExploreViewModel(service: Provider.of(context)),
        onModelReady: (model) async => await model.initialize(),
        builder: (context, ExploreViewModel model, Widget? child) {
          return Container(
            padding: EdgeInsets.all(16),
            child: _buildBody(context, model),
          );
        });
  }

  Widget _buildBody(BuildContext context, ExploreViewModel model) {
    if (model.busy) {
      return LoadingIndicator();
    }
    if (model.errorMessage != null) {
      return ErrorView(
          messages: model.errorMessage!,
          callback: () async => await model.initialize());
    }
    return ListView.builder(
      itemCount: model.places.length,
      padding: EdgeInsets.only(bottom: 12),
      itemBuilder: (BuildContext context, int index) {
        return _buildPlaceItem(context, model.places[index]);
      },
    );
  }

  Widget _buildPlaceItem(BuildContext context, PlaceModel place) {
    return Column(
      children: [
        ClipRRect(
          child: Image.network(getImage(place.image!)),
          borderRadius: BorderRadius.circular(12),
        ),
        SizedBox(height: 8),
        Text("${place.name}", style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 8),
        Text("Near: ${place.monument}"),
        SizedBox(height: 8),
        Text("${place.description}"),
        SizedBox(height: 12),

      ],
    );
  }
}

/*
return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://cdn.kimkim.com/files/a/content_articles/featured_photos/656bb11870d1786be69ae178e45d0723244384c6/big-3985131bf28128fdc4c2ffcd12779cb0.jpg",
            ),
          ),
          SizedBox(height: 8,),
          Text("Tinkune, theme park"), SizedBox(height: 8,),
          Text("Tinkune, Kathmandu, Nepal"), SizedBox(height: 8,),
          Text("It is a great place for family and friends to wander around and catcalling some stranger who also seek the peace and nature pristine calmness. "),
          SizedBox(height: 12,)

        ],
      ),
    );
 */
