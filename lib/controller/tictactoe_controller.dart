import 'package:flutter/material.dart';

class TictactoeController {
  final int _scaleTable = 3;
  int get scaleTable => _scaleTable;

  bool _xTurn = true;
  bool get xTurn => _xTurn;

  List<List<String>> _board = [];
  List<List<String>> get board => _board;

  // final List<List<List<String>>> _boardHistory = [];
  // List<List<List<String>>> get boardHistory => _boardHistory;

  final List<Map<String, dynamic>> _mapWinnerBoard = [];
  List<Map<String, dynamic>> get mapWinnerBoard => _mapWinnerBoard;

  int _xScore = 0;
  int get xScore => _xScore;

  int _oScore = 0;
  int get oScore => _oScore;

  void _initializaBoard() {
    _board =
        List.generate(_scaleTable, (index) => List.filled(_scaleTable, ''));
    _xTurn = true;
  }
  
  void _resetGame(){
    _initializaBoard();
    _xScore = 0;
    _oScore = 0;

  }

  void Function() get initialBoard => _initializaBoard;

  void Function() get resetGame => _resetGame;

  Future<void> _onTapped(BuildContext context, int row, int col) async{
    if (_board[row][col].isEmpty) {
      _board[row][col] = _xTurn ? 'X' : 'O';
      _xTurn = !_xTurn;

      String result = _checkWinner(context);
      if (result.isNotEmpty) {
        return showResultDialog(context, result);
      }
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
                title: Text('Invalid Tap'),
                content: Text('This box is already filled !'),
              ));
    }
  }

  String _checkWinner(BuildContext context) {
    for (int i = 0; i < _scaleTable; i++) {
      bool rowWin = true;
      bool colWin = true;
      for (int j = 1; j < _scaleTable; j++) {
        if (board[i][j] != board[i][0] || board[i][j].isEmpty) {
          rowWin = false;
        }
        if (board[j][i] != board[0][i] || board[j][i].isEmpty) {
          colWin = false;
        }
      }
      if (rowWin) {
        return board[i][0];
      }
      if (colWin) {
        return board[0][i];
      }
    }

    bool diag1Win = true;
    bool diag2Win = true;
    for (int i = 1; i < _scaleTable; i++) {
      if (board[i][i] != board[0][0] || board[i][i].isEmpty) {
        diag1Win = false;
      }
      if (board[i][_scaleTable - i - 1] != board[0][_scaleTable - 1] ||
          board[i][_scaleTable - i - 1].isEmpty) {
        diag2Win = false;
      }
    }
    if (diag1Win) {
      return board[0][0];
    }
    if (diag2Win) {
      return board[0][_scaleTable - 1];
    }

    bool isDraw = true;
    for (int i = 0; i < _scaleTable; i++) {
      for (int j = 0; j < _scaleTable; j++) {
        if (board[i][j].isEmpty) {
          isDraw = false;
          break;
        }
      }
    }
    if (isDraw) {
      return 'Draw';
    }
    return '';
  }

  Future<void> Function(BuildContext context, int row, int col) get onTapped =>
      _onTapped;

  void _keepScore(String result) {
    if (result == 'X') {
      _xScore++;
    } else if (result == 'O') {
      _oScore++;
    }
    _keepHistory(result);
  }

  void _keepHistory(String winner) {
    _mapWinnerBoard.add({
      'winner': winner,
      'board': _board,
    });
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content:
            Text(result == 'Draw' ? 'It\'s a draw!' : 'Player $result wins!'),
        actions: [
          TextButton(
            onPressed: () {
              _keepScore(result);
              _initializaBoard();
              Navigator.pop(context);
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void getHistoryBoard(int index) {
    _board = _mapWinnerBoard[index]['board'];
  }
}
