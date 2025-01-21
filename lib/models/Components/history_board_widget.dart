import 'package:flutter/material.dart';

class HistoryBoardWidget extends StatelessWidget {
  final int match;
  final String winner;
  const HistoryBoardWidget({
    super.key,
    required this.match,
    required this.winner,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Match $match'),
      leading: CircleAvatar(
        child: Text(winner == 'Draw' ? 'D' : winner),
      ),
    );
  }
}
