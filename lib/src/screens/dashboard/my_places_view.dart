import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/utils/image_helper.dart';
import 'package:places/src/viewmodels/dashboard/my_places_view_model.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/loading_indicator.dart';

class MyPlacesScreen extends StatelessWidget {
  const MyPlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MyPlacesViewModel>(
        model: locator<MyPlacesViewModel>(),
        onModelReady: (model) async => await model.initialize(),
        builder: (context, MyPlacesViewModel model, Widget? child) {
          return _buildBody(context, model);
        });
  }

  Widget _buildBody(BuildContext context, MyPlacesViewModel model) {
    if (model.busy) {
      return LoadingIndicator();
    }
    if (model.allPlaces.isEmpty) {
      return ErrorView(
          messages: "No places found.",
          callback: () async => await model.initialize());
    }
    return OrientationBuilder(
      builder: (context, Orientation orientation) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              childAspectRatio: 2),
          itemCount: model.allPlaces.length,
          padding: EdgeInsets.only(bottom: 12),
          itemBuilder: (BuildContext context, int index) {
            return buildMyPlaceItem(model, index);
          },
        );
      },
    );
  }

  Widget buildMyPlaceItem(MyPlacesViewModel model, int index) {
    final PlaceModel place = model.allPlaces[index];
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: ValueKey(place.sId!),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) => _onItemRemoved(place, model),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (_) {},

            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Update',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),
      child: Card(
        child: GridTile(
          header: Text(place.name!),
          footer: Text(
            place.description!,
            maxLines: 1,
          ),
          child: Image.network(place.image == null
              ? "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png"
              : getImage(place.image!)),
        ),
      ),
    );
  }

  void _onItemRemoved(PlaceModel place, MyPlacesViewModel model) {
    model.removePlace(place.sId!,place);
  }
}
