/*

Feed Page
Display what's new, basically a compilation fo their favourite stuff
Display lastest update <--  Shall update once data has been finalised

*/

import 'package:flutter/material.dart';
import 'example_data.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';


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

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            // Padding Widget: For the word Trending
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Trending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 46.0,
                    //fontFamily
                    letterSpacing: 1.0
                  ),)
                ],
              ),
            ),
        ElevatedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          label: Text("Log Out"),
          icon: Icon(Icons.logout_rounded),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              padding: MaterialStateProperty.all(EdgeInsets.all(16)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
          ),
        ),
            Stack(
              children: <Widget>[
                CardScrollWidget(currentPage),
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: images.length,
                    controller: controller,
                    reverse: true,
                    itemBuilder: (context, index){
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
