import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new CircularProgressIndicator(
        key: ArchSampleKeys.loading,
      ),
    );
  }
}
