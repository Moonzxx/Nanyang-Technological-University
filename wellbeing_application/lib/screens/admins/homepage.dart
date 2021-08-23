// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Homepage"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream:
                FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final docs = snapshot.data.docs;
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = docs[index];
                      return ListTile(
                        title: Text(user['name'] ?? user['email']),
                      );
                    },
                  );
                }
                return Column(
                  children: [
                    Center(child:CircularProgressIndicator(),),
                    Container(
                      height: MediaQuery.of(context).size.height / 30,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                          },
                          child: Text("Log Out")
                      ),
                    )
                  ],
                );
              }
            ),
          ],
        )
      ),
    );
  }
}

