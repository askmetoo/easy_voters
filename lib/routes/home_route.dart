import 'package:flutter/material.dart';

// Routes
import 'package:voters/routes/create_survey_route.dart';
import 'package:voters/routes/search_survey_route.dart';

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Voter"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new RaisedButton(
                onPressed: () => _pushCreate(context),
                child: new Text(
                  'Create a Survey',
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new RaisedButton(
                onPressed: () => _pushSearch(context),
                child: new Text(
                  'Search a Survey',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pushCreate(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          return CreateSurveyRoute();
        },
      ),
    );
  }

  void _pushSearch(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          return SearchSurveyRoute();
        },
      ),
    );
  }
}
