import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:voters/chart.dart';

const _radius = 32.0;
const REPORT_URL =
    'https://us-central1-easy-voters.cloudfunctions.net/sendReport';

class Survey extends StatefulWidget {
  final String docId;

  Survey({this.docId});

  @override
  SurveyState createState() => new SurveyState();
}

class SurveyState extends State<Survey> {
  final _selected = Set<DocumentReference>();
  List<Option> _options = [];
  var _db;
  var _reported = false;

  @override
  Widget build(BuildContext context) {
    _db = Firestore.instance.collection('surveys').document(widget.docId);

    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: new Text(
          'Survey',
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.assessment),
            onPressed: _displayChart,
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: new StreamBuilder(
        stream: _db.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return Material(
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                // radius
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  topRight: Radius.circular(_radius),
                ),
              ),
              child: _buildSurveyBody(snapshot.data));
        },
      ),
    );
  }

  Widget _buildSurveyBody(DocumentSnapshot document) {
    final bool _hasSelected = _selected.isNotEmpty;
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          new Text(
            "${document['name']}",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          new Divider(
            height: 10.0,
          ),
          new StreamBuilder(
            stream: _db.collection('options').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return new Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (_, int index) =>
                      _buildOption(snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                ),
              );
            },
          ),
          new ButtonBar(
            children: [
              new FlatButton(
                onPressed: _handleReport,
                child: new Text(
                  'Report',
                ),
                textColor: Colors.red,
              ),
              // new Expanded(
              //   child: new Container(),
              // ),
              new RaisedButton(
                onPressed: _hasSelected ? _handleSubmit : null,
                disabledColor: Colors.grey,
                child: new Text(
                  'Finish',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(DocumentSnapshot document) {
    final bool alreadySelected = _selected.contains(document.reference);
    newOption(document);

    return new ListTile(
      title: new Text(
        document.documentID,
      ),
      trailing: new Icon(
        alreadySelected ? Icons.check_circle : Icons.check_circle_outline,
        color: alreadySelected ? Colors.green : null,
      ),
      onTap: () => setState(() => alreadySelected
          ? _selected.remove(document.reference)
          : _selected.add(document.reference)),
    );
  }

  void newOption(DocumentSnapshot document) async {
    DocumentSnapshot option = await document.reference.get();
    _options.add(new Option(document.documentID, option['votes']));
  }

  void _displayChart() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          return new Chart(_options);
        },
      ),
    );
  }

  void _handleSubmit() {
    for (DocumentReference ref in _selected) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot option = await transaction.get(ref);
        await transaction
            .update(option.reference, {'votes': option['votes'] + 1});
      });
    }
    Navigator.pop(context);
  }

  Future<Null> _showReport() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Report'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Are you sure you wish to report this survey?'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('No'),
              onPressed: () {
                _reported = false;
                Navigator.of(context).pop();
              },
              textColor: Colors.black,
            ),
            new RaisedButton(
              child: new Text('Yes'),
              onPressed: () {
                _reported = true;
                Navigator.of(context).pop();
              },
              textColor: Colors.white,
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  void _handleReport() async {
    await _showReport();
    if (_reported) {
      var httpClient = new HttpClient();

      String result;
      try {
        var request = await httpClient
            .getUrl(Uri.parse(REPORT_URL + '?id=' + widget.docId));
        var response = await request.close();
        if (response.statusCode == HttpStatus.OK) {
          var data = await response.transform(utf8.decoder).join();
          result = data;
        } else {
          result =
              'Error getting a random quote:\nHttp status ${response.statusCode}';
        }
      } catch (exception) {
        result = 'Failed invoking the getRandomQuote function.';
      }

      print(result);
      Navigator.pop(context);
    }
  }
}

class Option {
  final String name;
  final int votes;

  Option(this.name, this.votes);
}
