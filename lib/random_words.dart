import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd)
          return Divider(); //Divider Constructors():Creates a material design divider.
        // Divider class--A thin horizontal line, with padding on either side.In the material design .
        // language, this represents a divider. Dividers can be used in lists, Drawers, and elsewhere to separate content.
        //To create a divider between ListTile items, consider using ListTile.divideTiles, which is optimized for this case.

        final index = item ~/
            2; //calculate the no. of word pairs that are in the ListView minus the divider widets//
        //here we don't want the dividers included here

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);

    return Card(
      child: ListTile(
          title: Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 18.0),
          ),
          trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                _savedWordPairs.remove(pair);
              } else {
                _savedWordPairs.add(pair);
              }
            });
          }),
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
        return ListTile(
            title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16.0)));
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
          appBar: AppBar(title: Text('Saved WordPairs')),
          body: ListView(children: divided));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WordPair Generator'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
          ],
        ),
        body: _buildList());
  }
}
