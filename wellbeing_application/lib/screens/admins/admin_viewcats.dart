import 'package:flutter/material.dart';
import 'package:wellbeing_application/constants.dart';
import 'package:wellbeing_application/widgets/custom_snackbar.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_page.dart';
import '../admins/TipsTools/admin_CreateTips.dart';
import '../admins/helpline/admin_searchHelpline.dart';
import '../admins/helpline/admin_createHelpline.dart';

class AdminViewCat extends StatefulWidget {
  final String category;
  AdminViewCat({ required this.category});

  @override
  _AdminViewCatState createState() => _AdminViewCatState();
}

class _AdminViewCatState extends State<AdminViewCat> {

  List<String> options = ["Create", "Delete"];
  List<String> option = ["Delete"];
  List<String> TipsToolsOption = ["Create", "Edit", "Delete"];
  List<String> HelplineOptions = ["Create", "Edit/Del"];
  int selectedIndex = -1;

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
                setState(() {
                  selectedIndex = index;
                  print(selectedIndex);
                });

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

  Widget TipsToolsAdminOptions(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: TipsToolsOption.length,
          itemBuilder: (BuildContext ctx, index){
            return GestureDetector(
              onTap: (){
                //make use of index
                setState(() {
                  selectedIndex = index;
                  print(selectedIndex);
                });

                // If 0, create
                if(selectedIndex == 0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTips() ));
                }

                // If 1, Edit
                // If 2, delete
                //Navigator.push(context, MaterialPageRoute(builder: (context) => ));
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(TipsToolsOption[index],style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                decoration : BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(15)),
              ),
            );
          }),
    );
  }

  Widget HelplineAdminOptions(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: HelplineOptions.length,
          itemBuilder: (BuildContext ctx, index){
            return GestureDetector(
              onTap: (){
                //make use of index
                setState(() {
                  selectedIndex = index;
                  print(selectedIndex);
                });

                // If 0, create
                if(selectedIndex == 0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => createaHelplineInfo() ));
                }
                if(selectedIndex == 1){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => searchSGClinic() ));
                }
                // If 1, Edit /Delete
                //Navigator.push(context, MaterialPageRoute(builder: (context) => ));
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(HelplineOptions[index],style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                decoration : BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(15)),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor:  Color(Constants.myThemeColour + 25).withOpacity(1),
      title: Text(widget.category, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            //top: Radius.circular(30),
              bottom: Radius.circular(30)
          )
      ),
    ),
      body: (widget.category == "USERS") ? adminGridOptions() :
      (widget.category == "TIPS") ? TipsToolsAdminOptions() :
      (widget.category == "HELPLINE") ? HelplineAdminOptions() : Container()// Maybe can else if here for different categories
    );
  }
}
