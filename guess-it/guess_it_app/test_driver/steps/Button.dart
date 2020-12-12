import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ITapButton extends When1WithWorld<String, FlutterWorld> {
  ITapButton() : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  RegExp get pattern => RegExp(r"I tap the {string}");

  @override
  Future<void> executeStep(String button) async {
    final locator = find.byValueKey(button);
    await FlutterDriverUtils.tap(world.driver, locator, timeout: timeout);
  }
}