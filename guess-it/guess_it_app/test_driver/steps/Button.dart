import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ITapButton extends WhenWithWorld<FlutterWorld> {
  ITapButton() : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  RegExp get pattern => RegExp(r"I tap the {string} button");

  @override
  Future<void> executeStep() async {
    final locator = find.byValueKey('Enter as Admin');
    await FlutterDriverUtils.tap(world.driver, locator, timeout: timeout);
  }
}