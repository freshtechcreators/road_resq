// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:road_resq/app.dart';

void main() {
  testWidgets('RoadResQ app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const RoadResQApp(),
    );

    expect(find.byType(RoadResQApp), findsOneWidget);
  });
}