import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/viewmodels/dashboard/explore_view_model.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/loading_indicator.dart';
import 'package:places/src/widgets/place_item.dart';
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
    if (model.places.status == false) {
      return ErrorView(
          messages: model.places.message!,
          callback: () async => await model.initialize());
    }
    return ListView.builder(
      itemCount: model.places.data.length,
      padding: EdgeInsets.only(bottom: 12),
      itemBuilder: (BuildContext context, int index) {
        final PlaceModel place = model.places.data[index] as PlaceModel;
        return PlaceItem(place: place,location:model.currentLocation);
      },
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
