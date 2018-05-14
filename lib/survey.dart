import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

const _radius = 46.0;

class Survey extends StatefulWidget {
  final String docId;

  Survey({this.docId});
  @override
  SurveyState createState() => new SurveyState();
}

class SurveyState extends State<Survey> {
  final _selected = Set<String>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: new Text(
          'Survey',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: new StreamBuilder(
        stream: Firestore.instance
            .collection('surveys')
            .document(widget.docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return Material(
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                // radius
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  topRight: Radius.circular(_radius),
                ), //BorderRadius.only(topLeft: Radius.circular(46.0)),
              ),
              child: _buildSurveyBody(snapshot.data));
        },
      ),
    );
  }

  Widget _buildSurveyBody(DocumentSnapshot document) {
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
          new Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, int index) =>
                  _buildOption(document['options'][index]),
              itemCount: document['options'].length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String option) {
    final bool alreadySelected = _selected.contains(option);
    return new ListTile(
      title: new Text(
        option,
      ),
      trailing: new Icon(
        alreadySelected ? Icons.check_circle : Icons.check_circle_outline,
        color: alreadySelected ? Colors.green : null,
      ),
      onTap: () => setState(() =>
          alreadySelected ? _selected.remove(option) : _selected.add(option)),
    );
  }
}
