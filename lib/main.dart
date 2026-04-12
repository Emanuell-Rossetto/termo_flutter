import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text('TermoFake'),
          ),
        ),
        body: Center(child: GamePage()),
      ),
    );
  }
}

class Tile extends StatelessWidget { 
  const Tile(this.letter, this.hitType ,{super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => const Color.fromARGB(255, 59, 109, 60),
          HitType.partial => const Color.fromARGB(255, 219, 198, 5),
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({super.key});


  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [  
          for (var guess in _game.guesses)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5.0,
              children: [
                for (var letter in guess) Tile(letter.char, letter.type),
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {


              if (_game.isLegalGuess(guess)){

                setState(() {
                  _game.guess(guess);
              });
                  
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text("${guess}, não é uma palavra valida"),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    )
                  );
                  
                }
              
            }
          ),
          if (_game.didWin) Text('Parabéns, você venceu!')
          else if (_game.didLose) Text('Que pena, você perdeu! A palavra era ${_game.hiddenWord}'),
        ],
      ),
      ),
    );
  }
}

//Lembrete (pergunta); Para todo novo widget de textfild precisa de uma classe pra ele? 

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();


  void _onSubmit() {
    onSubmitGuess(_textEditingController.text);
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 8.0),
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                )
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode,
              onSubmitted: (String value) {
                _onSubmit();
              },
            ),
          )
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: _onSubmit,
        )
      ],
    );
  }
}
