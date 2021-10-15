import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<String> mainCollections = ["users","forums","tips","tools"];

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
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(mainCollections[index]),
                decoration : BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(15)),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Homepage'),
        centerTitle: true,
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
