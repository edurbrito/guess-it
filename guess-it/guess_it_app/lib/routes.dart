import 'package:flutter/widgets.dart';
import 'screens/landing-page/landing-page.dart';
import 'screens/admin-code-page/admin-code-page.dart';
import 'screens/admin-panel-page/admin-panel-page.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => AdminPanel(),
  // "/ExScreen2": (BuildContext context) => ExScreen2(),
};