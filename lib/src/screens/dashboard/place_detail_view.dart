import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/src/model/dashboard/place_model.dart';
import 'package:places/src/utils/image_helper.dart';
import 'package:places/src/utils/location_helper.dart';
import 'package:places/src/widgets/dashboard/favorite_section.dart';
import 'package:places/src/widgets/map_view.dart';

class PlaceDetailView extends StatelessWidget {
  final PlaceModel place;

  const PlaceDetailView({Key? key, required this.place}) : super(key: key);

  final dummyText =
      """Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
  Why do we use it?
  It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).

  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeaderImage(context),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text("Near:${place.monument}"),
                      SizedBox(height: 12),
                      Text("${place.city}"),
                      SizedBox(height: 12),
                      Text("${place.address}"),
                      SizedBox(height: 12),
                      Text("${place.description}"),
                      SizedBox(height: 12),
                      _buildStaticImage(context),
                      SizedBox(height: 12),
                      Text(dummyText),
                      SizedBox(height: MediaQuery.of(context).size.height / 10),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      bottomSheet: _buildButton(context),
    );
  }

  Widget _buildStaticImage(BuildContext context) {
    // check if the image is already selected
    // if no then show a section showing no image selected
    // else show the image
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Image.network(
          LocationHelper.generateLocationPreviewImage(
              LatLng(place.latitude!, place.longitude!)),
          fit: BoxFit.cover,
          // loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? progress) {
          //   if (progress == null) return child;
          //   return Center(
          //     child: CircularProgressIndicator(
          //       value: progress.expectedTotalBytes != null ?
          //       progress.cumulativeBytesLoaded / progress.expectedTotalBytes!.toInt()
          //           : null,
          //     ),
          //   );
          // },
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return SliverAppBar(
      snap: true,
      pinned: true,
      stretch: true,
      floating: true,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            background: Hero(
              tag: Key(place.sId!),
              child: Image.network(
                getImage(place.image!),
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
              ),
            ),
            collapseMode: CollapseMode.pin,
            title: Text("${place.name}"),
          ),
          Positioned(
            child: FavoriteSection(placeId: place.sId!),
            right: 16,
            top: 48,
          )
        ],
      ),
      expandedHeight: MediaQuery.of(context).size.height / 3,
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) {
                  return MapView(
                      currentLocation:
                          LatLng(place.latitude!, place.longitude!));
                },
                fullscreenDialog: true));
          },
          child: Text("View on Map"),
        ),
      ),
    );
  }
}
