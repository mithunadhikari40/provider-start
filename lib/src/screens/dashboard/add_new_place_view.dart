import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/utils/location_helper.dart';
import 'package:places/src/utils/snackbar_helper.dart';
import 'package:places/src/viewmodels/dashboard/add_new_place_view_model.dart';
import 'package:places/src/widgets/bottomsheet/option_bottom_sheet.dart';
import 'package:places/src/widgets/input_name.dart';
import 'package:places/src/widgets/map_view.dart';
import 'package:places/src/widgets/shared/app_colors.dart';

class AddNewPlaceView extends StatelessWidget {
  AddNewPlaceView({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _monumentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: locator<AddNewPlaceViewModel>(),
      onModelReady: _onModelReady,
      builder:
          (BuildContext context, AddNewPlaceViewModel model, Widget? child) {
        return SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, model),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Add New Place",
      ),

      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AddNewPlaceViewModel model) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView(
        children: [
          InputName(
            controller: _titleController,
            text: "Place Name",
            hint: "e.g Lalitpur",
            icon: Icons.place,
          ),
          InputName(
            controller: _monumentController,
            text: "Nearby monument ",
            hint: "e.g Dharahara",
            icon: Icons.place,
          ),
          InputName(
            controller: _descriptionController,
            text: "Place description",
            hint: "describe this place",
            icon: Icons.message,
            lines: 3,
          ),
          _buildInputImage(context, model),
          _buildStaticImage(context, model),
          _buildSubmitButton(context, model),
        ],
      ),
    );
  }

  Widget _buildInputImage(BuildContext context, AddNewPlaceViewModel model) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          _pickImage(context, model);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 5,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              // borderRadius: BorderRadius.circular(16)
            ),
            child: Center(
              child: model.imagePath != null
                  ? Image.file(
                File(model.imagePath!),
                fit: BoxFit.cover,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 5,
              )
                  : Text(
                "No Image selected",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _onModelReady(AddNewPlaceViewModel model) {}

  void _pickImage(BuildContext context, AddNewPlaceViewModel model) {
    /// give user an option to select image from camera or gallery
    showOptionBottomSheet(
      context,
      "Pick Image Using",
      "Camera",
      "Gallery",
          () => _saveImage(context, model, ImageSource.camera),
          () => _saveImage(context, model, ImageSource.gallery),
    );
  }

  void _saveImage(BuildContext context, AddNewPlaceViewModel model,
      ImageSource source) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file == null) {
      return showSnackBar(context, "Could not pick image, please try again");
    }
    model.setImage(file.path);
  }

  Widget _buildStaticImage(BuildContext context, AddNewPlaceViewModel model) {
    return InkWell(
      onTap: () {
        _chooseLocationMethod(context, model);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height / 5,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            // borderRadius: BorderRadius.circular(16)
          ),
          child: Center(
            child: model.location != null
                ? Image.network(
              LocationHelper.generateLocationPreviewImage(
                  model.location!),
              fit: BoxFit.cover,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 5,
            )
                : Text(
              "No Location Selected",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6,
            ),
          ),
        ),
      ),
    );
  }

  void _chooseLocationMethod(BuildContext context, AddNewPlaceViewModel model) {
    showOptionBottomSheet(
      context,
      "Choose Location Using",
      "Map",
      "Current Location",
          () => _chooseLocationFromMap(context, model),
          () => model.setUserCurrentLocation(),
    );
  }

  Future<void> _chooseLocationFromMap(BuildContext context,
      AddNewPlaceViewModel model) async {
    LatLng? result =
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return MapView(
        readOnly: false,
        currentLocation: model.userCurrentLocation,
        onLocationSelected: (location) {
          model.setUserCurrentLocation(latLng: location);
        },

      )
    },
        fullscreenDialog: true
    ));
    // if (result != null) {
    //   model.setUserCurrentLocation(latLng: result);
    // }
  }

  Widget _buildSubmitButton(BuildContext context, AddNewPlaceViewModel model) {
    print("Is busy ${model.busy}");
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: ButtonTheme(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        child: ElevatedButton(
          onPressed: model.busy
              ? null
              : () {
            _onSubmit(context, model);
          },
          child: model.busy ? CircularProgressIndicator() : Text("Submit"),
        ),
      ),
    );
  }

  Future _onSubmit(BuildContext context, AddNewPlaceViewModel model) async {
    bool validData = validateData(context, model);
    if (!validData) return;
    final response = await model.submitData(
        _titleController.text, _monumentController.text,
        _descriptionController.text);
    if(response.status){
      showSnackBar(context, "New place added successfully");
      Navigator.of(context).pop(true);
    }else{
      showSnackBar(context, response.message ?? "");
    }
  }

  bool validateData(BuildContext context, AddNewPlaceViewModel model) {
    if (_titleController.text.isEmpty) {
      showSnackBar(context, "Place name is required.");
      return false;
    }
    if (_monumentController.text.isEmpty) {
      showSnackBar(context, "Monument is required.");
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      showSnackBar(context, "Description is required.");
      return false;
    }
    if (model.imagePath == null) {
      showSnackBar(context, "Please provide a place photo.");
      return false;
    }
    if (model.location == null) {
      showSnackBar(context, "Please choose a location.");
      return false;
    }
    return true;
  }
}
