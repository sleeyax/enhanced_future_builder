import 'dart:async';

import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('when done and not done', (tester) async {
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

  testWidgets('initial data', (tester) async {
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

  testWidgets('when error', (tester) async {
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

  testWidgets('when waiting', (tester) async {
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

  testWidgets('when none', (tester) async {
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

  testWidgets('when error and no handler', (tester) async {
    final completer = Completer<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnhancedFutureBuilder(
            rememberFutureResult: true,
            future: completer.future,
            whenDone: (data) => Text('$data'),
            whenNotDone: Text('Not done'),
          ),
        ),
      ),
    );

    expect(find.text('Not done'), findsOneWidget);

    completer.completeError('Error');

    await tester.pump();

    expect(find.text('Not done'), findsOneWidget);
  });

  testWidgets('remember future result', (tester) async {
    var future = Future.value(42);
    late void Function(void Function()) setStateFn;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(builder: (context, setState) {
          setStateFn = setState;
          return Scaffold(
            body: EnhancedFutureBuilder(
              rememberFutureResult: true,
              future: future,
              whenDone: (data) => Text('$data'),
              whenNotDone: Text('Not done'),
            ),
          );
        }),
      ),
    );

    await tester.pump();
    expect(find.text('42'), findsOneWidget);

    setStateFn(() {
      future = Future.value(43);
    });
    await tester.pumpAndSettle();
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('do not remember future result', (tester) async {
    var future = Future.value(42);
    late void Function(void Function()) setStateFn;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(builder: (context, setState) {
          setStateFn = setState;
          return Scaffold(
            body: EnhancedFutureBuilder(
              rememberFutureResult: false,
              future: future,
              whenDone: (data) => Text('$data'),
              whenNotDone: Text('Not done'),
            ),
          );
        }),
      ),
    );

    await tester.pump();
    expect(find.text('42'), findsOneWidget);

    setStateFn(() {
      future = Future.value(43);
    });
    await tester.pumpAndSettle();
    expect(find.text('43'), findsOneWidget);
  });
}
