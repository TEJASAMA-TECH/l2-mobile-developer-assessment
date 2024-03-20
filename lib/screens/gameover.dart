import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatefulWidget {
  final int score;
  final int missed;

  const GameOverScreen({Key? key, required this.score, required this.missed}) : super(key: key);

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    'assets/images/background.png',
                  width: 150,
                ),
                Text(
                  'Score: ${2 * widget.score - widget.missed}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Destroyed: ${widget.score}',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Missed: ${widget.missed}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Navigate back to the game screen
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Button color
                  ),
                  icon: Icon(
                    Icons.replay, // Replay icon
                    color: Colors.white, // Icon color
                  ),
                  label: Text(
                    'Replay',
                    style: TextStyle(
                      color: Colors.white, // Text color
                    ),
                  ),
                ),

              ],
            ),
          ),
          // Confetti animation
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 50,
            gravity: 0.1,
            maxBlastForce: 20,
            minBlastForce: 5,
            emissionFrequency: 0.01,
          ),
        ],
      ),
    );
  }
}
