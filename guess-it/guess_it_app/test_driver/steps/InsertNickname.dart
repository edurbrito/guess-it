import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class InsertNickname extends GivenWithWorld<FlutterWorld> {
  InsertNickname() : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  RegExp get pattern => RegExp(r"I insert a nickname");

  @override
  Future<void> executeStep() async {
    final locator = find.byValueKey('text-field');
    await FlutterDriverUtils.enterText(world.driver, locator, 'SomeNick');
  }
}