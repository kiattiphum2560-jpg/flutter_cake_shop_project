// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_cake_shop_project/main.dart';

void main() {
  testWidgets('Cake shop app displays the splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlutterCakeShopApp());

    expect(find.text('สายด่วนกินเค้ก'), findsOneWidget);
    expect(find.text('CAKE CALL FAST'), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
  });
}
