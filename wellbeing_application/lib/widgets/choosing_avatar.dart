// @dart=2.10

/*
 Choosing Avatar:
 Can stay anonymous, try issuing 3 icons, together with adding media gallery and a default.
 Can tryto make it collapsible

 */
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../utils/firebase_api.dart';
import 'package:flutter/services.dart';
import 'DataHolder.dart';
import '../constants.dart';
import 'create_profile.dart';

// Image picker to get images from gallery, can be used in profile page


// Whne it goes back, it still shows the lcoal selected file

class ChooseAvatar extends StatefulWidget {
  final String accountUID;
  ChooseAvatar({Key key, this.accountUID}) : super(key: key);

  @override
  _ChooseAvatarState createState() => _ChooseAvatarState();
}

class _ChooseAvatarState extends State<ChooseAvatar> {
  //Underscore means private
  int MAX_SIZE = 7*1024*1024;
  Uint8List imageFile;
  Uint8List bytes;
  File _image;
  File _chosenImage;
  String chosenImageName;
  UploadTask _task;
  int selectedCard = -1;
  int testing;
  Uint8List diplay;
  bool choseDef = false;
  bool choseSelf = false;
  bool atLeastChosen = false;


  @override
  Widget build(BuildContext context) {

    // If user were to backtrack, the application will reset the photo in cache.
    _image = null;
    bytes;
    final fileName = _image != null ? basename(_image.path) : 'No File Selected';


    Future selectFile() async {
      // Only allow to select one file
      final result = await FilePicker.platform.pickFiles(allowMultiple:  false);

      if(result == null) return;
      final path = result.files.single.path;

      setState(() async {
        _image = File(path);
        chosenImageName = basename(_image.path);
        await _image.readAsBytes().then((value) {
         // bytes = Uint8List.fromList(value);
          setState(() {
            bytes = Uint8List.fromList(value);
            choseSelf = true;
            choseDef = false;
            atLeastChosen = true;
          });


          print('Reading of bytes ic completed');
        }).catchError((onError){
          print('Exception Error while reading audio from path: ' + onError.toString());
        });
      });
    }

    // TO show the percentage in real-time
    Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context,snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);

          return Text('%percentage %',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
        }
        else
        {
          return Container();
        }
      },
    );


    @override
    void initState(){
      super.initState();
    }

    /* Future uploadFile(BuildContext context) async{
      String fileName = basename(_image.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      uploadTask.then((res) => setState(() {
        print("Profile Picture uploaded");
        final message = "Profile Picture has been updated";
        final snackBar = SnackBar(
          content: Text(
            message,
            style: TextStyle(fontSize: 20),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }));
    } */

    /*

    Widget makeImageGrid(){
      // Need to find a way tos ave images that have already retrieved
      return GridView.builder(
        itemCount: 6,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:  3),
          itemBuilder: (context, index){
            //return ImageGridItem(index+1);
            return GestureDetector(
              onTap: (){
                setState(() {
                  selectedCard = index;
                });
              },
              child: Card(
                color: selectedCard == index ? Colors.blue : Colors.amber,
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: ImageGridItem(index),
                    ),
                  ],
                ),

              ),
            ); // Tryiong to add the plus button for own image

          });
    }
    */




    Widget makeImageGrid(){
      // Need to find a way tos ave images that have already retrieved
      return GridView.builder(
          itemCount: 6,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:  3,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 10.0
          ),
          itemBuilder: (context, index){
            //return ImageGridItem(index+1);
            return GestureDetector(
              onTap: (){
                setState(() {
                  selectedCard = index;
                  setState(() {
                    choseDef = true;
                    choseSelf = false;
                    atLeastChosen = true;
                  });
                  print(index);
                });
              },
              child: Stack(
                children: <Widget>[
                  ImageGridItem(index),
                  Card(
                    // Imge being chosen; Color will change according to selection
                    color: selectedCard == index ? Colors.transparent : Colors.black.withOpacity(0.4),
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)
                    ),
                    // The reason for the black background is because of the elevation
                    elevation: 0.0,
                    child:
                    Container(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ); // Trying to add the plus button for own image

          });
    }

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: Colors.lightBlue,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );


    // button clickable after
    Widget buildNextButton() => ElevatedButton(onPressed: atLeastChosen ? (){
      if( bytes != null && choseSelf == true)
      {
        setState(() {
          imageFile = bytes;
          testing = selectedCard;
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateProfile(chosenProfilePic: imageFile, accountUID: widget.accountUID)
            ),
          );
        });
      }
      else{
        Reference photosReference = FirebaseStorage.instance.ref().child("profilepics");
        photosReference.child("default_${selectedCard}.jpg").getData(MAX_SIZE).then((data) {
          setState(() {
            imageFile = data;
            testing = selectedCard;
            print("Profile UID Pt 3: ${widget.accountUID}");
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateProfile(chosenProfilePic: imageFile, accountUID: widget.accountUID)
              ),
            );
          });
        });
      }


    } : null,
        style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20)),
        child: Text('Next Step'));

    /* TextButton(
      style: flatButtonStyle,
      onPressed:() {
        if( bytes != null && choseSelf == true)
          {
            setState(() {
              imageFile = bytes;
              testing = selectedCard;
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateProfile(chosenProfilePic: imageFile, accountUID: widget.accountUID)
                ),
              );
            });
          }
        else{
          Reference photosReference = FirebaseStorage.instance.ref().child("profilepics");
          photosReference.child("default_${selectedCard}.jpg").getData(MAX_SIZE).then((data) {
            setState(() {
              imageFile = data;
              testing = selectedCard;
              print("Profile UID Pt 3: ${widget.accountUID}");
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateProfile(chosenProfilePic: imageFile, accountUID: widget.accountUID)
                ),
              );
            });
          });
        }


      },
      child: Text('Next Step'),
    );

*/


    /*
    Original start of the code*/

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kChoosingAvatarTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(kChoosingAvatarTitle),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 140.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //Text("You can selected from either of this siz default avatars or choose to use your own picture.", textAlign: TextAlign.center,),
                /*
                Align(
                  alignment: Alignment.center,
                  heightFactor: 2.7,
                  child: Container(
                    width: 100.0,
                    height:100.0,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 1.0)
                    ),
                    child:
                      Icon(
                        Icons.account_circle, size: 15.0
                      ),
                  ),
                ),
                 */
                Container(
                  height: MediaQuery.of(context).size.height /3,
                  width: MediaQuery.of(context).size.width * 0.95,
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(40
                      ),
                    ),
                    child: Center(
                      child: makeImageGrid(),
                    ),
                  ),
                ),
                const SizedBox(height:20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: selectFile,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: (bytes != null) ? Image.memory(bytes,fit: BoxFit.fill).image : Image.asset("assets/images/HealthyLifestylePoster.png").image,
                        backgroundColor: Colors.white,

                      ),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(onPressed: selectFile, child: Text("Add"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          onPrimary: Colors.black,
                          shadowColor: Colors.white,
                          elevation: 5,
                          side: BorderSide(color: Colors.red, width:2),
                          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),

                _task != null ? buildUploadStatus(_task) : Container(),
                SizedBox(height: 30),
                buildNextButton(),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

// Need to call MakeImageGrid() to call for pictures in database



class ImageGridItem extends StatefulWidget {
  int _index;

  ImageGridItem(int index){
    this._index = index;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  Uint8List imageFile;
  Reference photosReference = FirebaseStorage.instance.ref().child("profilepics");

  getImage(){
    if(!requestedIndexes.contains(widget._index)){
      int MAX_SIZE = 7*1024*1024;
      photosReference.child("default_${widget._index}.jpg").getData(MAX_SIZE).then((data){
        this.setState(() {
          imageFile = data;
          // Create class for iamge file to be given function?
        });
        // Checking if the item is absent. If it is, then add the image to the file.
        imageData.putIfAbsent(widget._index, (){
          return data;
        });
      }).catchError((error){
        debugPrint(error.toString());
      });
      requestedIndexes.add(widget._index);
    }
  }

  // If the image file is null. if null, return text view
  decideGridTileViewWidget(){
    if(imageFile == null){
      return Center(child: Text("No Data") );
    } else{
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.memory(imageFile,fit: BoxFit.fill)
      );
    }
  }

  // WIll be called everytime the state is initialised
  @override
  void initState(){
    super.initState();
    // If it does not contain the key, then we need to get the image
    if(!imageData.containsKey(widget._index)){
      getImage();
    }else{
      this.setState(() {
        imageFile = imageData[widget._index];
      });
    }
  }

  // itembuilder is like a forloop



  @override
  Widget build(BuildContext context){
    return GridTile(
        child: decideGridTileViewWidget(),
      );

  }
  /*
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: InkWell(
        onTap: (){
          // Not sure if we need to set state
          return Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 10.0)
            ),
            child:
              Icon(Icons.check_circle)
          );
          // It is working
          // Alright, so when clicked, get the image, make the make the image as profile
          /* showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Testing'),
              content:  Text('It is working'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed:  () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ); */
        },
        child: decideGridTileViewWidget()
      ),
    );
  }

   */




}



