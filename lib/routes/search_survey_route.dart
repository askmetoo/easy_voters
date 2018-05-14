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
        centerTitle: true,
      ),
      body: new Center(
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: new Row(
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
      ),
    );
  }

  void _handleSubmitted(BuildContext context) {
    // _textController.clear();

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          return Survey(docId: _textController.text);
        },
      ),
    );
  }
}
