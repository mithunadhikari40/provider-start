import 'package:flutter/material.dart';

Future<T> showOverlayLoadingIndicator<T>(
    BuildContext context, Future<T> future) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        );
      });
  final response = await future;
  Navigator.of(context).pop();
  return response;
}
