import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:balloonblast/screens/gameover.dart';
class MainGame extends StatefulWidget {
  const MainGame({Key? key}) : super(key: key);

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  late Timer _timer;
  Random random = Random();
  List<_Object> _objects = [];
  double _speed = 3;
  double _gravity = 0.1;
  late Size _screenSize;
  int _numObjects = 1; // Number of objects to spawn
  double _spawnFrequency = 1.0; // Example frequency: 1 spawn per second
  int _destroyedCount = 0;
  int _missedCount = 0; // Count of missed animated containers that reached the top
  Duration _gameDuration = Duration(seconds: 120); // Total duration of the game
  late int _timeLeft; // Time left in the game

  @override
  void initState() {
    super.initState();
    _screenSize = Size(0, 0); // Initialize _screenSize with default values
    _timeLeft = _gameDuration.inSeconds; // Initialize time left to total game duration
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _screenSize = MediaQuery.of(context).size; // Initialize _screenSize after the first frame is rendered
      _startSpawning(); // Start spawning immediately
      _startMovement(); // Start movement immediately
      _startGameTimer(); // Start the game timer
      _startTimerUpdate(); // Start the timer to update time left display
    });
  }

  void _startSpawning() {
    _timer = Timer.periodic(Duration(seconds: 1 ~/ _spawnFrequency), (timer) {
      _spawnObjects(); // Spawn objects at the specified frequency
    });
  }

  void _spawnObjects() {
    setState(() {
      for (int i = 0; i < _numObjects; i++) {
        double x = random.nextDouble() * (_screenSize.width - 24); // Random x coordinate within the screen width
        double y = _screenSize.height; // Start from the bottom of the screen
        double size = random.nextDouble() * 30 + 50; // Random text size between 10 and 30
        String imageUrl = 'assets/images/b${random.nextInt(4) + 1}.png'; // Random image URL
        _objects.add(_Object(Offset(x, y), size, imageUrl)); // Add object with random size and image URL
      }
    });
  }


  void _startMovement() {
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        for (int i = 0; i < _objects.length; i++) {
          double currentSpeed = _speed; // Store the current speed
          _objects[i].position = Offset(_objects[i].position.dx, _objects[i].position.dy - currentSpeed); // Move object upwards with constant speed
          if (_objects[i].position.dy < 0.0) {
            if (!_objects[i].destroyed) {
              _missedCount++; // Increment missed count if the object reached the top without being destroyed
            }
            _objects.removeAt(i); // Remove object when it goes out of screen
          }
        }
      });
    });
  }

  void _destroyObject(int index) {
    setState(() {
      _objects[index].destroyed = true; // Mark the object as destroyed
      _objects.removeAt(index); // Remove the object
      _destroyedCount++; // Increment destroyed count
    });
  }

  void _startGameTimer() {
    Timer(_gameDuration, () {
      // Redirect to game over screen when game duration is reached
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => GameOverScreen(score: _destroyedCount, missed: _missedCount),
      ));
    });
  }

  void _startTimerUpdate() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--; // Decrease the time left
      });
      if (_timeLeft <= 0) {
        timer.cancel(); // Stop the timer when time is up
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/score.png" ,
                      height: 35,
                    ),
                    Text('${2 * _destroyedCount- _missedCount}'),
                  ],
                ),

                Container(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1.0, end: _timeLeft <= 10 ? 1.2 : 1.0),
                    duration: Duration(milliseconds: 500),
                    builder: (_, scale, __) {
                      return Transform.scale(
                        scale: scale,
                        child: Row(
                          children: [
                            Icon(Icons.timer,
                              color: _timeLeft <= 10 ? Colors.red : Colors.black,),
                            Text(
                              '$_timeLeft s',
                              style: TextStyle(
                                color: _timeLeft <= 10 ? Colors.red : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ],
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/images/thorns.png'),
          Expanded( // Wrap the Stack with an Expanded widget
            child: Stack(
              children: _objects.asMap().entries.map((entry) {
                final index = entry.key;
                final object = entry.value;
                return Positioned(
                  left: object.position.dx,
                  top: object.position.dy,
                  child: GestureDetector(
                    onTap: () {
                      _destroyObject(index);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 16),
                      child: Image.asset(
                        object.imageUrl, // Use the image URL from the object
                        width: object.size, // Use object size to adjust the width of the image
                        height: object.size, // Use object size to adjust the height of the image
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),

    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
class _Object {
  Offset position;
  double size;
  bool destroyed = false; // Flag to track if the object is destroyed
  String imageUrl; // URL of the image

  _Object(this.position, this.size, this.imageUrl);
}
