import 'package:flutter/material.dart';
import 'admin_viewcats.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<String> mainCollections = ["USERS","FORUMS","TIPS","TOOLS", "HELPLINE"];
  String cat= "";

  int selectedCard = -1;

  @override
  void initState(){
    super.initState();
  }


  Widget adminGridOptions(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
          itemCount: mainCollections.length,
          itemBuilder: (BuildContext ctx, index){
            return GestureDetector(
              onTap: (){
                //make use of index
                setState(() {
                  cat = mainCollections[index];
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminViewCat(category: cat)));
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(mainCollections[index],style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
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
          backgroundColor: Colors.blue[700],
          title: Text("Admin Homepage", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),
        ),
      body:  adminGridOptions()

    );
  }
}

/*
Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Users'),
              ElevatedButton(
                onPressed: (){},
                child: Text("Create/Update/Delete users"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    fixedSize: Size(300,100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    )
                ),
              ),

            ],
          ),
        ),
 */
