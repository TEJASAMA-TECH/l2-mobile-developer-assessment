import 'package:flutter/material.dart';
import 'screens/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue, // Set primary color to blue
      ),
      home: const MyHomePage(title: 'Balloon Blast'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainGame()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.yellow, // Set background color to blue
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // Big circle in the middle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'Balloon\nBlast',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Start button with white background and blue text
              ElevatedButton(
                onPressed: () => _startGame(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
