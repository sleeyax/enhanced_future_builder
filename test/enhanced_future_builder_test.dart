import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EnhancedFutureBuilder', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnhancedFutureBuilder(
            rememberFutureResult: true,
            future: Future.value(42),
            whenDone: (data) => Text('$data'),
            whenNotDone: Text('Not done'),
          ),
        ),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('Not done'), findsOneWidget);

    // Trigger a frame.
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('42'), findsOneWidget);
  });
}
