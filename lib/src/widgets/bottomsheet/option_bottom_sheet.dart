import 'package:flutter/material.dart';

void showOptionBottomSheet(BuildContext context,String title, String positiveButtonText,
    String negativeButtonText, VoidCallback positiveButtonTap, VoidCallback negativeButtonTap) {
  showModalBottomSheet(
      context: context,
      elevation: 12,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: ElevatedButton(

                        onPressed: () {
                          Navigator.of(context).pop();
                          positiveButtonTap();
                        },
                        child: Text(positiveButtonText),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: ElevatedButton(

                        onPressed: () {
                          Navigator.of(context).pop();
                          negativeButtonTap();
                        },
                        child: Text(negativeButtonText),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 12)
          ],
        );
      });
}