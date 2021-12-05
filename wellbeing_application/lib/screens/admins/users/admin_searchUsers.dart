// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/constants.dart';
import '../../../widgets/custom_AlertBox.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key key}) : super(key: key);

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {

  TextEditingController searchUserController = new TextEditingController();
  FirebaseApi database = new FirebaseApi();
  QuerySnapshot searchSnapshot = null;

  initiateSearch(){
    database.getUserbyUsername(searchUserController.text) //searchTextEditingController.text
        .then((val){
      setState(() {
        // Need to set that so that searchList can be updated
        searchSnapshot = val;
      });
      print(searchSnapshot.docs[0]["username"]);
      //print(searchSnapshot.docs.map((doc) => doc.data() ));
    });
  }



  Widget searchList(){

    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          // create a for loop to check user
          return SearchTile(userName: searchSnapshot.docs[index]["username"],
              avatarURL: searchSnapshot.docs[index]["url-avatar"],
              otherUserID: searchSnapshot.docs[index]["userID"]);

        })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Search User")),
        body: Container(
          child: Column(
              children: <Widget>[
                Container(
                  color: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchUserController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Search Username",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          initiateSearch();
                        },
                        child: Container(
                            height: 40, width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(Icons.send_rounded, color: Colors.blue),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                searchList()
              ]
          ),
        )
    );
  }
}



class SearchTile extends StatelessWidget {
  final String userName;
  final String avatarURL;
  final String otherUserID;
  SearchTile({this.userName, this.avatarURL, this.otherUserID});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/10,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        elevation: 5,
        child: ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(width: 2, color: Color(Constants.myThemeColour + 25).withOpacity(1),)
          ),
          title: Text(this.userName),
          trailing: IconButton(onPressed: (){
              CustomAlertBox.deleteUser(context, "Delete User? ", this.otherUserID);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
          }, icon: Icon(Icons.delete, color: Colors.blueGrey )),

        ),
      ),
    );
  }
}
