import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tranzfort_tms/main.dart';

void main() {
  testWidgets('Tranzfort TMS App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: TranzfortTMSApp(),
      ),
    );

    // Just pump once without settling
    await tester.pump();

    // Verify that the app loads
    expect(find.byType(TranzfortTMSApp), findsOneWidget);
  });
}
