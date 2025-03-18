import 'package:all_in_app/components/custom_app_bar.dart';
import 'package:all_in_app/components/games_category.dart';
import 'package:all_in_app/pages/apps/games/memory_game.dart';
import 'package:all_in_app/pages/apps/games/tic_tac_toe.dart';
import 'package:flutter/material.dart';

class GamesMain extends StatelessWidget {
  final List _games = [
    [
      'Tic Tac Toe',
      'Challenge your friends!',
      Icon(Icons.grid_view, color: Colors.red, size: 40),
    ],
    [
      'Memory Game',
      'Memorize the items!',
      Icon(Icons.light_mode),
    ],
  ];
  final List<Widget> _gamePages = [
    TicTacToe(),
    MemoryGame(),
  ];

  GamesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Games', appBarColor: Colors.redAccent),
      body: ListView.builder(
          itemCount: _games.length,
          itemBuilder: (BuildContext context, int index) {
            return GamesCategory(
              gameName: _games[index][0],
              gameDescription: _games[index][1],
              gameIcon: _games[index][2],
              onPlay: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return _gamePages[index];
                }));
              },
            );
          }),
    );
  }
}
