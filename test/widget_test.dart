import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tranzfort_tms/main.dart';
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/presentation/providers/database_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('Tranzfort TMS App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('hi'),
          Locale('pa'),
          Locale('ta'),
          Locale('te'),
          Locale('mr'),
          Locale('gu'),
          Locale('bn'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(AppDatabase.forTesting()),
          ],
          child: const TranzfortTMSApp(),
        ),
      ),
    );

    // Just pump once without settling
    await tester.pump();

    // Verify that the app loads
    expect(find.byType(TranzfortTMSApp), findsOneWidget);
  });
}
