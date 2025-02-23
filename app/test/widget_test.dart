import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('Roomloo App loads successfully', (WidgetTester tester) async {
    // Build the RoomlooApp and trigger a frame.
    await tester.pumpWidget(const RoomlooApp());

    // Check if the Home Page title exists.
    expect(find.text('Roomloo'), findsOneWidget);

    // Verify the bottom navigation bar exists.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
