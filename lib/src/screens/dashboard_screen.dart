import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:places/src/widgets/shared/app_colors.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Places", style: TextStyle(color: blackColor87)),
        backgroundColor: whiteColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 40,
              color: blackColor87,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Center(
        child: Text("We show the list of todos here"),
      ),
    );
  }
}
