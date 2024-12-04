import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Guess Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Guess Game'),
        backgroundColor: Colors.deepPurple,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('About', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), // Set your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image.jpg', width: 200, height: 200),
              const SizedBox(height: 20),
              const Text(
                'Word Guess Game',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const UsernameScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Start Game', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Username'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.jpg'), // Set your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                  hintText: 'Enter your username',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_usernameController.text.isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(username: _usernameController.text),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String username;

  const GameScreen({required this.username, super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<Map<String, String>> _wordsWithHints = [
    {'word': 'HAPPY', 'hint': 'Feeling or showing pleasure or contentment', 'image': 'assets/happy.jpg'},
    {'word': 'MOBILE', 'hint': 'A portable device for communication', 'image': 'assets/mobile.jpg'},
    {'word': 'FLUTTER', 'hint': 'Software development kit created by google', 'image': 'assets/flutter.jpg'},
    {'word': 'DART', 'hint': 'A small pointed missile that can be thrown or fired', 'image': 'assets/dart.jpg'}
  ];

  late String _currentWord;
  late String _currentHint;
  late String _currentImage;
  late List<String> _guessedLetters;
  late int _wrongGuesses;
  late int _score;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      final selectedWord = (_wordsWithHints..shuffle()).first;
      _currentWord = selectedWord['word']!;
      _currentHint = selectedWord['hint']!;
      _currentImage = selectedWord['image']!;
      _guessedLetters = [];
      _wrongGuesses = 0;
      _score = 0;
    });
  }

  void _guessLetter(String letter) {
    setState(() {
      if (_guessedLetters.contains(letter)) return;
      _guessedLetters.add(letter);
      if (!_currentWord.contains(letter)) {
        _wrongGuesses++;
      } else {
        _score += 10;
      }
    });
  }

  bool get _hasWon {
    for (var letter in _currentWord.split('')) {
      if (!_guessedLetters.contains(letter)) return false;
    }
    return true;
  }

  bool get _hasLost => _wrongGuesses >= 6;

  void _nextQuestion() {
    if (_hasWon || _hasLost) {
      _startNewGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Guess Game - ${widget.username}'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Score: $_score',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg2.jpg'), // Set your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_currentImage, width: 80, height: 80),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text('Hint: $_currentHint', style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                children: _currentWord
                    .split('')
                    .map((letter) {
                      final color = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
                      return Chip(
                        label: Text(_guessedLetters.contains(letter) ? letter : '_'),
                        backgroundColor: color,
                        padding: const EdgeInsets.all(8.0),
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 20),
              if (_hasWon)
                const Text('Congrats! You won!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
              if (_hasLost)
                const Text('Sorry! You lost!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 20),
              if (_hasWon || _hasLost)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _startNewGame,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 35, 158, 62),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('New Game', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SplashScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 142, 6, 17),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Back', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                  return ElevatedButton(
                    onPressed: () => _guessLetter(letter),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12.0),
                      backgroundColor: const Color.fromARGB(255, 50, 168, 241),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(letter, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
