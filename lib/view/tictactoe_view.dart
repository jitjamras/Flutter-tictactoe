import 'package:flutter/material.dart';
import 'package:tic_tac_toe/index.dart';

class TictactoeView extends StatefulWidget {
  const TictactoeView({super.key});

  @override
  State<TictactoeView> createState() => _TictactoeViewState();
}

class _TictactoeViewState extends State<TictactoeView> {
  final TictactoeController controller = TictactoeController();

  @override
  void initState() {
    controller.initialBoard();
    super.initState();
  }

  void _showHistoryModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.blue[200],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text('History Board',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold))))),
              Expanded(
                flex: 4,
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: controller.mapWinnerBoard.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () =>
                            setState(() => controller.getHistoryBoard(index)),
                        child: HistoryBoardWidget(
                            match: index + 1,
                            winner: controller.mapWinnerBoard[index]
                                ['winner']))),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PlayerScoreWidget(player: 'Player X', score: controller.xScore),
                PlayerScoreWidget(player: 'Player O', score: controller.oScore),
                _buildHistoryButton(context),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.scaleTable),
                  itemCount: controller.scaleTable * controller.scaleTable,
                  itemBuilder: (BuildContext context, int index) {
                    final row = index ~/ controller.scaleTable;
                    final col = index % controller.scaleTable;
                    return GestureDetector(
                      onTap: () {
                        controller.onTapped(context, row, col).then(
                              (value) => setState(() {}),
                            );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Colors.indigo[700]),
                        child: Center(
                          child: Text(
                            controller.board[row][col],
                            style: TextStyle(
                              color: controller.board[row][col] == 'X'
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // foreground
                ),
                onPressed: () => setState(() {
                  controller.resetGame();
                }),
                child: Text("Clear Score Board"),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  _showHistoryModalBottomSheet(context);
                });
              },
              icon: Icon(
                Icons.history_rounded,
                size: 30,
                color: Colors.white,
              )),
          Text(
            'History Board',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
