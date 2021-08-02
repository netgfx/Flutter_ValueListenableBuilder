import 'package:flutter/material.dart';
import 'package:flutter_valuenotifierbuilder/sprite_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final ValueNotifier<int> counter = ValueNotifier<int>(0);
  Offset particlePoint = Offset(0, 0);
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) {
            print("tap");
            setState(() {
              particlePoint = details.globalPosition;
            });
          },
          onTapCancel: () {
            print("cancel tap");
            setState(() {
              //points.add(null);
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              ValueListenableBuilder<int>(
                valueListenable: counter,
                builder: (BuildContext context, int value, Widget? child) {
                  // This builder will only get called when the _counter
                  // is updated.
                  print(value);
                  return child!;
                },
                child: Transform.translate(
                  offset: Offset(viewportConstraints.maxWidth / 2, 0),
                  child: SpriteWidget(
                    viewportConstraints: viewportConstraints,
                    particlePoint: Offset(500, viewportConstraints.maxHeight / 2),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.pointsList});
  List<DrawingPoints?> pointsList;
  List<Offset> offsetPoints = [];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        var path = Path();
        path.addOval(Rect.fromCircle(center: pointsList[i]!.points, radius: 25.0));
        //canvas.drawLine(pointsList[i]!.points, pointsList[i + 1]!.points, pointsList[i]!.paint);
        canvas.drawShadow(path.shift(Offset(pointsList[i]!.points.dx - 5, pointsList[i]!.points.dy - 5)), Colors.black54, 5.0, true);
        canvas.drawPath(path, pointsList[i]!.paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        // offsetPoints.add(pointsList[i]!.points);
        // offsetPoints.add(Offset(pointsList[i]!.points.dx + 0.1, pointsList[i]!.points.dy + 0.1));
        // canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i]!.paint);
        var path = Path();
        path.addOval(Rect.fromCircle(center: pointsList[i]!.points, radius: 25.0));
        canvas.drawShadow(path, Colors.black87, 5.0, true);
        canvas.drawPath(path, pointsList[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({required this.points, required this.paint});
}
