import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile/profile.dart';
import '../widgets/navigation_drawer.dart';
//Testing
import '../widgets/choosing_avatar.dart';
import '../constants.dart';

class DisplaTipCategories extends StatelessWidget {
  List<int> top = <int>[];
  List<int> bottom = <int>[0];

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-silver-list');

    return Scaffold(
      appBar: AppBar(
        title: Text(kTipsCategoriesTitle),
        // Leading for the side Menu
        /*leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: (){
            setState((){ // Why cant SetState be initialised(?)
              top.add(-top.length -1);
              bottom.add(bottom.length);
            });
          },
        ), */
      ),
      body: CustomScrollView(
        center: centerKey,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index){
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.blue[200 + top[index] % 4 * 100],
                    height: 100 + top[index] % 4 * 20.0,
                    child: Text('Item: ${top[index]}'),
                  );
                },
              childCount: top.length,
            ),
          ),
          SliverList(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.blue[200 + top[index] % 4 * 100],
                    height: 100 + bottom[index] % 4 * 20.0,
                    child: Text('Item: ${bottom[index]}'),
                  );
                },
              childCount: bottom.length
            ),
          ),
        ],
      ),
    );
  }
}
