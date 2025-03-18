import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:all_in_app/themes/theme_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Importă AdMob

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final List<String> _images = [
    'lib/assets/banana.jpg',
    'lib/assets/cherry.jpg',
    'lib/assets/grapes.jpg',
    'lib/assets/kiwi.jpg',
    'lib/assets/lemon.jpg',
    'lib/assets/orange.jpg',
    'lib/assets/pear.jpg',
    'lib/assets/watermelon.jpg',
    'lib/assets/banana.jpg',
    'lib/assets/cherry.jpg',
    'lib/assets/grapes.jpg',
    'lib/assets/kiwi.jpg',
    'lib/assets/lemon.jpg',
    'lib/assets/orange.jpg',
    'lib/assets/pear.jpg',
    'lib/assets/watermelon.jpg',
  ];

  late List<bool> _flipped;
  late List<int> _selectedCards;
  late List<bool> _matchedCards;
  int _score = 0;

  late InterstitialAd _interstitialAd; // Declară interstitialul
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _resetGame();

    // Încarcă interstitialul
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-6666037133413674/7130046400', // Folosește ID-ul de interstitial al aplicației tale
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('Failed to load interstitial ad: ${error.message}');
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _interstitialAd.show();
    }
  }

  void _resetGame() {
    setState(() {
      _flipped = List.generate(_images.length, (_) => false);
      _selectedCards = [];
      _matchedCards = List.generate(_images.length, (_) => false);
      _score = 0;
      _shuffleCards();
    });
  }

  void _shuffleCards() {
    final random = Random();
    _images.shuffle(random);
  }

  void _onCardTapped(int index) {
    if (_flipped[index] || _matchedCards[index] || _selectedCards.length == 2) {
      return;
    }

    setState(() {
      _flipped[index] = true;
      _selectedCards.add(index);
    });

    if (_selectedCards.length == 2) {
      _checkMatch();
    }
  }

  void _checkMatch() async {
    int firstCard = _selectedCards[0];
    int secondCard = _selectedCards[1];

    if (_images[firstCard] == _images[secondCard]) {
      setState(() {
        _matchedCards[firstCard] = true;
        _matchedCards[secondCard] = true;
        _score += 10;
      });
    } else {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _flipped[firstCard] = false;
        _flipped[secondCard] = false;
      });
    }
    setState(() {
      _selectedCards.clear();
    });

    if (_matchedCards.every((matched) => matched)) {
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    // Arată reclama intercalată când jocul este câștigat
    _showInterstitialAd();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Congratulations!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'You won the game!',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.blueGrey : Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: const Text(
                  'Play Again',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Curăță resursele
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Memory Game',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
      ),
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onCardTapped(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _flipped[index] || _matchedCards[index]
                          ? (isDarkMode ? Colors.grey[700] : Colors.grey[300])
                          : (isDarkMode ? Colors.blueGrey : Colors.blueAccent),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: _flipped[index] || _matchedCards[index]
                        ? Image.asset(
                            _images[index],
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 36,
                          ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Score: $_score',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
