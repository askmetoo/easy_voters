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
  final _selected = Set<DocumentReference>();
  var _db;

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
      ),
      backgroundColor: Colors.blue,
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
              }),
          new RaisedButton(
            onPressed: _hasSelected ? _handleSubmit : null,
            textColor: Colors.white,
            color: Colors.blueAccent,
            disabledColor: Colors.grey,
            child: new Text(
              'Finish',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(DocumentSnapshot document) {
    final bool alreadySelected = _selected.contains(document.reference);
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

  void _handleSubmit() {
    print('Submitting selections');
    for (DocumentReference ref in _selected) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(ref);
        await transaction
            .update(freshSnap.reference, {'votes': freshSnap['votes'] + 1});
      });
    }
  }
}
