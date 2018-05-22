import 'package:flutter/material.dart';

import 'package:voters/survey.dart';

class SearchSurveyRoute extends StatelessWidget {
  final _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(
          'Search for a Survey',
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: (String text) => _handleSubmitted(context),
                decoration: new InputDecoration.collapsed(
                  hintText: 'Survey ID...',
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(BuildContext context) async {
    if (_textController.text.isEmpty) return;

    await Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          return Survey(docId: _textController.text);
        },
      ),
    );
  }
}
