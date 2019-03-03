import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  LoadingSpinner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
