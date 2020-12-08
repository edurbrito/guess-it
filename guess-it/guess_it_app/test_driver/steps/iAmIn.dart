import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ExpectToBeInPage extends Given1WithWorld<String, FlutterWorld> {
  ExpectToBeInPage() : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  RegExp get pattern => RegExp(r"I am in the {string}");

  @override
  Future<void> executeStep(String name) async {
    bool isInPage = await FlutterDriverUtils.isPresent(world.driver, find.byType(name));
    expectMatch(isInPage, true);
  }
}