import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'cat_api.dart';
import 'models/cat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;
  final CatApi _api = CatApi();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget _showCatWidget(Cat? cat) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(child: Image.network(cat?.url ?? '')),
          Text('Image width: ${cat?.width} - height: ${cat?.height}')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clicked $_counter times')
      ),
      body: EnhancedFutureBuilder(
          future: widget._api.getRandomCat(),
          // this is where the magic happens
          rememberFutureResult: true,
          whenDone: (Cat? cat) => _showCatWidget(cat),
          whenError: (Object? error) => Text(error.toString()),
          whenNotDone: Center(child: Text('Loading...'))),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Clicked $_counter times')
  //     ),
  //     body: FutureBuilder(
  //       future: widget._api.getRandomCat(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return _showCatWidget(snapshot.data);
  //         }else {
  //           return Center(child: Text('Loading...'));
  //         }
  //       }
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Increment',
  //       child: Icon(Icons.add),
  //     ),
  //   );
  // }
}
