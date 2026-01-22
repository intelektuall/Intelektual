import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Sopan Santun App - Integration Test', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver?.close();
    });

    test('App launches', () async {
      // Simple check that app launches
      expect(driver, isNotNull);
    });
  });
}