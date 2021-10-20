/*

Feed Page
Display what's new, basically a compilation fo their favourite stuff
Display lastest update <--  Shall update once data has been finalised

*/

import 'package:flutter/material.dart';
import 'example_data.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;


/*
Need ot get images and title, then link to the pages
 */

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _FeedPageState extends State<FeedPage> {
  var currentPage = images.length - 1.0;
  List eg = [[0.7, Colors.blue, "Be Active"],
    [0.7, Colors.green, "Be Aware"],
    [0.25, Colors.pinkAccent, "Connect"],
    [0.35, Colors.deepPurpleAccent, "Keep Learning"],
    [0.8, Colors.yellow, "Help Others"]];

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });




    getGridView(){
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1,
            crossAxisSpacing: 60,
            mainAxisSpacing: 60
        ),
        itemCount: 5,
        itemBuilder: (BuildContext ctx, index){
          return roundstats(percentage: eg[index][0], color: eg[index][1], cat: eg[index][2]);
        },
         );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Wellbeing", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: getGridView()
    );
  }
}


class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;
        
        List<Widget> cardList = [];
        
        for(var i = 0; i < images.length; i++){
          var delta = i - currentPage;
          bool isOnRight = delta > 0;
          
          var start = padding + 
        max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);
          
          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta,0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3.0, 6.0),
                    blurRadius: 10.0),
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(images[i], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                              child: Text(title[i],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                // font family
                              )),
                            ),
                            SizedBox(height: 10.0),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 12.0, right: 12.0
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 6.0
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20.0)
                                ),
                                child: Text("Read Later",
                                style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}


class roundstats extends StatelessWidget {
  final double percentage;
  final String cat;
  final Color color;
  roundstats({ required this.percentage, required this.color, required this.cat});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: this.percentage, // Have ot be double
      center: Text(
        "${this.percentage*100}%",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
        ),
      ),
      footer: Text(
        cat,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17.0
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: color,
    );
  }
}
