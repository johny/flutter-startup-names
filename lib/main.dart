import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _words = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  void _pushSavedView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {

        final Iterable<ListTile> savedTiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(pair.asPascalCase, style: _biggerFont),
            );
          }
        );

        final List<Widget> dividedList = ListTile.divideTiles(
          context: context,
          tiles: savedTiles
        ).toList();

        return Scaffold(
          appBar: AppBar(title: Text('Saved Words')),
          body: ListView(children: dividedList)
        );

      })
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        // divider every row
        if (i.isOdd) {
          return Divider();
        }

        final int index = i ~/ 2;
        if (index >= _words.length) {
          _words.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_words[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool isSaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.redAccent : Colors.grey,
      ),
      onTap: () {
        setState(() {
          isSaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Names Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSavedView),
        ]
      ),
      body: _buildList()
    );
  }
}
