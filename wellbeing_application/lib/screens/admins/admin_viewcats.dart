import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/custom_snackbar.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_page.dart';

class AdminViewCat extends StatefulWidget {
  final String category;
  AdminViewCat({ required this.category});

  @override
  _AdminViewCatState createState() => _AdminViewCatState();
}

class _AdminViewCatState extends State<AdminViewCat> {

  List<String> options = ["Create", "Delete"];
  List<String> option = ["Delete"];

  Widget adminGridOptions(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: option.length,
          itemBuilder: (BuildContext ctx, index){
            return GestureDetector(
              onTap: (){
                //make use of index

                //Navigator.push(context, MaterialPageRoute(builder: (context) => ));
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(option[index],style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                decoration : BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(15)),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.blue[700],
      title: Text(widget.category, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            //top: Radius.circular(30),
              bottom: Radius.circular(30)
          )
      ),
    ),
      body: adminGridOptions()
    );
  }
}
