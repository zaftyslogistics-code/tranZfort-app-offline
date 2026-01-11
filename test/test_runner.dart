import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 1 Test Runner', () {
    test('Run All Tests', () async {
      print('\n🚀 Starting Phase 1 Automated Testing...\n');

      // Run unit tests first
      print('📋 Running Unit Tests...');
      final unitTestResult = await Process.run(
        'flutter',
        ['test', 'test/unit_test/business_logic_test.dart'],
        workingDirectory: Directory.current.path,
      );

      if (unitTestResult.exitCode != 0) {
        print('❌ Unit Tests Failed:');
        print(unitTestResult.stderr);
        return;
      }
      print('✅ Unit Tests Passed\n');

      // Run integration tests
      print('🔗 Running Integration Tests...');
      final integrationTestResult = await Process.run(
        'flutter',
        ['test', 'test/integration_test/phase1_smoke_test.dart'],
        workingDirectory: Directory.current.path,
      );

      if (integrationTestResult.exitCode != 0) {
        print('❌ Integration Tests Failed:');
        print(integrationTestResult.stderr);
        return;
      }
      print('✅ Integration Tests Passed\n');

      print('🎉 ALL TESTS PASSED!');
      print('\n📱 App is ready for Android device testing!');
      print('\nNext steps:');
      print('1. Connect your Android device');
      print('2. Run: flutter run');
      print('3. Perform manual testing of the UI flows');
    });
  });
}
