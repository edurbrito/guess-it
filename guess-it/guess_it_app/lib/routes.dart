import 'package:flutter/widgets.dart';
import 'package:guess_it_app/screens/player-page/player-page.dart';
import 'screens/landing-page/landing-page.dart';
import 'screens/admin-code-page/admin-code-page.dart';
import 'screens/admin-panel-page/admin-panel-page.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => LandingPanel(),
  "/AdminCode": (BuildContext context) => AdminCode(),
  "/AdminPanel": (BuildContext context) => AdminPanel(),
  "/PlayerConfig": (BuildContext context) => PlayerConfig(),
};