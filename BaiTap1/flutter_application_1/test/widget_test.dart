// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Calculator initial display smoke test', (WidgetTester tester) async {
    // Build our calculator app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());

    // Verify initial expression/result text.
    expect(find.text('0'), findsWidgets); // expression and result may both show 0
    expect(find.text('Error'), findsNothing);

    // Tap a digit and equals, assert result.
    await tester.tap(find.text('7'));
    await tester.pump();
    await tester.tap(find.text('×'));
    await tester.pump();
    await tester.tap(find.text('8'));
    await tester.pump();
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('56.0'), findsOneWidget);
  });
}
