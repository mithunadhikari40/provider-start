import 'package:flutter/material.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/viewmodels/dashboard/add_to_favorite_view_model.dart';
import 'package:places/src/widgets/shared/app_colors.dart';

class FavoriteSection extends StatelessWidget {
  final String placeId;

  const FavoriteSection({Key? key, required this.placeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddToFavoriteViewModel>(
        model: locator<AddToFavoriteViewModel>(),
        onModelReady: (model) => model.isFavoritePlace(placeId),
        builder: (BuildContext context, AddToFavoriteViewModel model,
            Widget? child) {
          return IconButton(
            onPressed: () => model.addOrRemoveFromFavorite(placeId),
            icon: Icon(
              model.isFavorite
                  ? Icons.favorite_outlined
                  : Icons.favorite_border,
              size: 32,
              color: whiteColor,
            ),
            iconSize: 32,
            color: whiteColor,
          );
        });
  }
}
