import 'package:all_in_app/components/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Importul pentru AdMob

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  bool xTurn = true; // Este rândul lui X să mute?
  List<String> _square = ['', '', '', '', '', '', '', '', ''];
  int scoreO = 0; // Scor pentru O
  int scoreX = 0; // Scor pentru X
  String resultMessage = '';

  // AdMob interstitial ad
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // Inițializarea AdMob și încărcarea reclamei interstitiale
    _loadInterstitialAd();
  }

  // Funcția pentru încărcarea reclamei interstitiale
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-6666037133413674/7130046400', // ID-ul interstitial
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
            print('Failed to load interstitial ad: $error');
          }
        },
      ),
    );
  }

  // Funcția pentru a arăta reclama interstitială
  void _showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _interstitialAd.show();
      _loadInterstitialAd(); // Reîncarcă reclama pentru a fi disponibilă mai târziu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      appBar: CustomAppBar(title: 'Tic Tac Toe', appBarColor: Colors.red[800]!),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildScoreBoard(),
            _buildGrid(),
            _buildResultMessage(),
            _buildRestartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _scoreCard('Player X', scoreX, Colors.redAccent),
          _scoreCard('Player O', scoreO, Colors.white),
        ],
      ),
    );
  }

  Widget _scoreCard(String player, int score, Color color) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(height: 8),
        Text(
          score.toString(),
          style: TextStyle(
              color: color, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 300, // Dimensiune fixă pentru a preveni scroll-ul
        height: 300,
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          physics:
              NeverScrollableScrollPhysics(), // Dezactivăm scroll-ul grilei
          children: List.generate(9, (index) {
            return GestureDetector(
              onTap: () {
                _tapped(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    _square[index],
                    style: TextStyle(
                      color:
                          _square[index] == 'X' ? Colors.white : Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildResultMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        resultMessage,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRestartButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _restartGame,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Restart Game',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  void _tapped(int index) {
    if (_square[index] == '' && resultMessage == '') {
      setState(() {
        _square[index] = xTurn ? 'X' : 'O';
        xTurn = !xTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    List<List<int>> winningPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linii
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Coloane
      [0, 4, 8], [2, 4, 6], // Diagonale
    ];

    for (var position in winningPositions) {
      if (_square[position[0]] != '' &&
          _square[position[0]] == _square[position[1]] &&
          _square[position[1]] == _square[position[2]]) {
        setState(() {
          resultMessage = 'Player ${_square[position[0]]} Wins!';
          if (_square[position[0]] == 'X') {
            scoreX++;
          } else {
            scoreO++;
          }
        });

        // Afișează reclama după ce jocul se termină
        _showInterstitialAd();
        return;
      }
    }

    if (!_square.contains('')) {
      setState(() {
        resultMessage = 'It\'s a Draw!';
      });

      // Afișează reclama după remiză
      _showInterstitialAd();
    }
  }

  void _restartGame() {
    setState(() {
      _square = ['', '', '', '', '', '', '', '', ''];
      resultMessage = '';
      xTurn = true;
    });
  }
}
