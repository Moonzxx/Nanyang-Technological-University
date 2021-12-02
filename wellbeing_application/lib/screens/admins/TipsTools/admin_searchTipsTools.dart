// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import '../../../widgets/custom_AlertBox.dart';
import 'admin_editTipsPost.dart';
import 'admin_editToolsPost.dart';

class SearchTipsTools extends StatefulWidget {
  const SearchTipsTools({Key key}) : super(key: key);

  @override
  _SearchTipsToolsState createState() => _SearchTipsToolsState();
}

class _SearchTipsToolsState extends State<SearchTipsTools> {
  FirebaseApi databaseMethods = new FirebaseApi();
  List<String> TipsToolsSubCategories = [];
  String selectedSubCat;
  Stream TipsToolsPosts;

  String selectedCategory;
  List<String> categories = ["Tips", "Tools"];

  @override
  void initState() {
    super.initState();
  }

  getTTCategories(String category) async {
    QuerySnapshot coll = await FirebaseFirestore.instance
        .collection("tips")
        .doc(category)
        .collection("categories")
        .get();
    List<DocumentSnapshot> collDocs = coll.docs;
    print(collDocs.length); // returns 3
    for (var i = 0; i < collDocs.length; i++) {
      setState(() {
        TipsToolsSubCategories.add(collDocs[i]['name']);
      });
    }
  }

  useSearch(String region) {
    databaseMethods.getTTCatPosts(selectedCategory, selectedSubCat).then((val) {
      setState(() {
        TipsToolsPosts = val;
      });
    });
  }

  // choose to shoe Tips or Toosl
  Widget displayTipToolsPostList() {
    return StreamBuilder(
      stream: TipsToolsPosts,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TipsPostTiles(
                    mainCategory: selectedCategory,
                    subCategory: selectedSubCat,
                    postName: (snapshot.data as QuerySnapshot).docs[index]
                        ["name"],
                    postSources: (snapshot.data as QuerySnapshot).docs[index]
                        ["sourcesFrom"],
                    postContent: (snapshot.data as QuerySnapshot).docs[index]
                        ["content"],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
          "Search Posts",
          style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 30),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                bottom: Radius.circular(30))),
        actions: [
          IconButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
              },
              icon: Icon(Icons.search_rounded, color: Colors.white))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton(
              value: selectedCategory,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 20,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(height: 2, color: Colors.black),
              onChanged: (String newValue) {
                setState(() {
                  selectedCategory = newValue;
                  TipsToolsSubCategories = [];
                  getTTCategories(selectedCategory);
                  // refresh second dropdown
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList()),
          SizedBox(height: 20),
          DropdownButton(
              value: selectedSubCat,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 20,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(height: 2, color: Colors.black),
              onChanged: (String newValue) {
                setState(() {
                  selectedSubCat = newValue;
                  useSearch(selectedSubCat);
                });
              },
              items: TipsToolsSubCategories.map<DropdownMenuItem<String>>(
                  (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList()),
          SizedBox(height: 20),
          displayTipToolsPostList()
          //DisplaySGRegionClinicList(),
        ],
      ),
    );
  }
}

class TipsPostTiles extends StatelessWidget {
  final String mainCategory;
  final String subCategory;
  final String postName;
  final String postContent;
  final List<dynamic> postSources;

  TipsPostTiles(
      {this.postName,
      this.mainCategory,
      this.postContent,
      this.subCategory,
      this.postSources});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.play_arrow_rounded),
          title: Text(this.postName),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTipsPosts(
                                mainCat: this.mainCategory,
                                subCat: this.subCategory,
                                postName: this.postName,
                                postContent: this.postContent,
                                postSource: this.postSources)));
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
                  },
                  icon: Icon(Icons.edit, color: Colors.blueGrey)),
              SizedBox(width: 2),
              IconButton(
                  onPressed: () {
                    CustomAlertBox.deleteTipsToolsPost(context, "Delete Post?",
                        this.mainCategory, this.subCategory, this.postName);
                    //CustomAlertBox.deleteSGClinicInfo(context, "Delete Clinic?", sgRegionSelected, sgRegionClinicName);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
                  },
                  icon: Icon(Icons.delete, color: Colors.blueGrey))
            ],
          ),
        ),
      ),
    );
  }
}

class ToolsPostTiles extends StatelessWidget {
  final String mainCategory;
  final String subCategory;
  final String postName;
  final String postContent;
  final String postIosSource;
  final String postAndroidSource;

  ToolsPostTiles(
      {this.postName,
      this.mainCategory,
      this.postContent,
      this.subCategory,
      this.postIosSource,
      this.postAndroidSource});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.play_arrow_rounded),
          title: Text(this.postName),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditToolsPosts(
                                  mainCat: this.mainCategory,
                                  subCat: this.subCategory,
                                  postName: this.postName,
                                  postContent: this.postContent,
                                  postIosSource: this.postIosSource,
                                  postAndoridSource: this.postAndroidSource,
                                )));
                  },
                  icon: Icon(Icons.edit, color: Colors.blueGrey)),
              SizedBox(width: 2),
              IconButton(
                  onPressed: () {
                    CustomAlertBox.deleteTipsToolsPost(context, "Delete Post?",
                        this.mainCategory, this.subCategory, this.postName);
                    //CustomAlertBox.deleteSGClinicInfo(context, "Delete Clinic?", sgRegionSelected, sgRegionClinicName);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
                  },
                  icon: Icon(Icons.delete, color: Colors.blueGrey))
            ],
          ),
        ),
      ),
    );
  }
}
