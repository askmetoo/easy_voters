import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:voters/survey.dart';

class Chart extends StatelessWidget {
  var optionsList;
  final options;

  Chart(this.options) {
    this.optionsList = [
      new charts.Series<Option, String>(
        id: 'Options',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Option option, _) => option.name,
        measureFn: (Option option, _) => option.votes,
        data: options,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: new Text(
          'Survey\'s Chart',
        ),
        centerTitle: true,
      ),
      body: new charts.BarChart(
        optionsList,
        animate: false,
      ),
    );
  }
}
