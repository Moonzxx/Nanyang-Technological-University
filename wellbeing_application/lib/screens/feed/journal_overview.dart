import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:percent_indicator/percent_indicator.dart';
import '../journal/round_overview_stats.dart';

/*
Display all the five parts
 */


class JournalOverview extends StatefulWidget {
  const JournalOverview({Key? key}) : super(key: key);

  @override
  _JournalOverviewState createState() => _JournalOverviewState();
}


class _JournalOverviewState extends State<JournalOverview> {



  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            WellbeingCategory(rowCount: 1),
        WellbeingCategory(rowCount: 2),
          WellbeingCategory(rowCount: 3),

            ],
          ),
      ),
    );
  }
}

class WellbeingCategory extends StatelessWidget {

  int rowCount;
  WellbeingCategory({required this.rowCount});

  RoundOverviewStats connect = new RoundOverviewStats(statPercentage: 0.7, statTitle: "Connect", statColour: Colors.pinkAccent);
  RoundOverviewStats beAware = new RoundOverviewStats(statPercentage: 0.5, statTitle: "Be Aware", statColour: Colors.green);
  RoundOverviewStats beActive = new RoundOverviewStats(statPercentage: 0.1, statTitle: "Be Active", statColour: Colors.lightBlue);
  RoundOverviewStats helpOthers = new RoundOverviewStats(statPercentage: 0.95, statTitle: "Help Others", statColour: Colors.yellow);
  RoundOverviewStats keepLearning = new RoundOverviewStats(statPercentage: 0.3, statTitle: "Keep Learning", statColour: Colors.deepPurple);

  @override
  Widget build(BuildContext context) {
    if (rowCount == 1)
      {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround ,
          children: <Widget>[
            connect, beAware,
          ],
        );
      }
    if (rowCount == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround ,
        children: <Widget>[
          beActive, helpOthers,
        ],
      );
    }
    if (rowCount == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround ,
        children: <Widget>[
          keepLearning
        ],
      );
    }
    return Row();
  }
}
