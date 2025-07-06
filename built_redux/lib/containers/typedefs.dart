import 'package:flutter/src/widgets/framework.dart';

typedef ViewModelBuilder<ViewModel> =
    Widget Function(BuildContext context, ViewModel vm);
