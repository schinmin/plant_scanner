import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_scanner_app/main.dart';

void main() {
  testWidgets('App renders the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('AI Alert'), findsOneWidget);
    expect(find.byIcon(Icons.eco), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
  });
}
