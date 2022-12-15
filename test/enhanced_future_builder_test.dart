import 'dart:async';

import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EnhancedFutureBuilder when done and not done', (WidgetTester tester) async {
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

    expect(find.text('Not done'), findsOneWidget);

    await tester.pump();

    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('EnhancedFutureBuilder initial data', (WidgetTester tester) async {
    final completer = Completer<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnhancedFutureBuilder(
            rememberFutureResult: true,
            initialData: 42,
            future: completer.future,
            whenDone: (data) => Text('$data'),
            whenNotDone: Text('Not done'),
          ),
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);

    completer.complete(43);

    await tester.pump();

    expect(find.text('43'), findsOneWidget);
  });

  testWidgets('EnhancedFutureBuilder when error', (WidgetTester tester) async {
    final completer = Completer<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnhancedFutureBuilder(
            rememberFutureResult: true,
            future: completer.future,
            whenDone: (data) => Text('$data'),
            whenNotDone: Text('Not done'),
            whenError: (error) => Text('Error: $error'),
          ),
        ),
      ),
    );

    expect(find.text('Not done'), findsOneWidget);

    completer.completeError('Error');

    await tester.pump();

    expect(find.text('Error: Error'), findsOneWidget);
  });

  testWidgets('EnhancedFutureBuilder when waiting', (WidgetTester tester) async {
    final completer = Completer<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnhancedFutureBuilder(
            rememberFutureResult: true,
            future: completer.future,
            whenDone: (data) => Text('$data'),
            whenNotDone: Text('Not done'),
            whenWaiting: Text('Waiting'),
          ),
        ),
      ),
    );

    expect(find.text('Waiting'), findsOneWidget);

    completer.complete(43);

    await tester.pump();

    expect(find.text('43'), findsOneWidget);
  });

  testWidgets('EnhancedFutureBuilder when none', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnhancedFutureBuilder(
            rememberFutureResult: true,
            future: null,
            whenDone: (data) => Text('$data'),
            whenNotDone: Text('Not done'),
            whenNone: Text('None'),
          ),
        ),
      ),
    );

    expect(find.text('None'), findsOneWidget);
  });
}
