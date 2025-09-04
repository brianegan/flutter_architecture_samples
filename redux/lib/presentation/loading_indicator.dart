import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key = ArchSampleKeys.todosLoading});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
