import 'package:flutter/widgets.dart';

class EnhancedFutureBuilder extends StatefulWidget {
  /// Future to resolve.
  final Future future;
  /// Whether or not the future result should be stored.
  final bool rememberFutureResult;
  /// Widget to display when connected to an asynchronous computation.
  final Widget whenActive;
  /// Widget to display when connected to an asynchronous computation and awaiting interaction.
  final Widget whenWaiting;
  /// Widget to display when not connected to n asynchronous computation.
  final Widget whenNone;
  /// Widget to display when the asynchronous computation is not done yet.
  final Widget whenNotDone;
  /// Function to call when the asynchronous computation is done.
  final Widget Function(dynamic snapshotData) whenDone;
  /// The data that will be used until a non-null [future] has completed.
  ///
  /// See [FutureBuilder] for more info
  final dynamic initialData;

  const EnhancedFutureBuilder({
    Key key, 
    @required this.future,
    @required this.rememberFutureResult,
    @required this.whenDone,
    this.whenActive,
    this.whenNotDone,
    this.whenNone,
    this.whenWaiting,
    this.initialData
  }) : 
  assert(future != null),
  assert(rememberFutureResult != null), 
  assert(whenDone != null), 
  super(key: key);

  @override
  _EnhancedFutureBuilderState createState() => _EnhancedFutureBuilderState();
}

class _EnhancedFutureBuilderState extends State<EnhancedFutureBuilder> {

  Future _cachedFuture;

  @override 
  void initState() {
    super.initState();
    _cachedFuture = this.widget.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.widget.rememberFutureResult ? _cachedFuture : this.widget.future,
      initialData: this.widget.initialData,
      builder: (BuildContext context, snapshot) {
        if (this.widget.whenActive != null && snapshot.connectionState == ConnectionState.active) {
          return this.widget.whenActive;
        }
        
        if (this.widget.whenNone != null && snapshot.connectionState == ConnectionState.none) {
          return this.widget.whenNone;
        }
        
        if (this.widget.whenWaiting != null && snapshot.connectionState == ConnectionState.waiting) {
          return this.widget.whenWaiting;
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return this.widget.whenDone(snapshot.data);
        }

        if (this.widget.whenNotDone != null && snapshot.connectionState != ConnectionState.done) {
          return this.widget.whenNotDone;
        }
      },
    );
  }
}