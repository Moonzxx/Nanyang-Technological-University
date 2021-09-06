import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RoundOverviewStats extends StatelessWidget {
  const RoundOverviewStats({Key? key, required this.statPercentage, required this.statTitle, required this.statColour}) : super(key: key);
  final double statPercentage;
  final String statTitle;
  final statColour;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: statPercentage, // Have ot be double
      center: Text(
        "${statPercentage*10}%",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
        ),
      ),
      footer: Text(
        statTitle,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17.0
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: statColour,
    );
  }
}
