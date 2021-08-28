// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:package_info/package_info.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // For the form, important for validation

  // For Firebase Authentication
  //May need to modify this for error sake

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _formKey2 = GlobalKey<FormState>();
  bool _autoValidate2 = false;


  // Since we will have multiple state for the page
  int _pageState = 0; // Get Started Screen
  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB189AB4);

  double _headingTop = 100;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffeset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;

  String _email;
  String _password;

  @override
  void initState() {

    emailController.addListener((){
      //here you have the changes of your textfield
      print("value: ${emailController.text}");
      _email = emailController.text;
      //use setState to rebuild the widget
      setState(() {

      });
    });

    passwordController.addListener((){
      //here you have the changes of your textfield
      print("value: ${passwordController.text}");
      _password = passwordController.text;
      //use setState to rebuild the widget
      setState(() {

      });
    });

    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed: $visible");
        });
      },
    );
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }





  // Firebase methods
  Future<void> _createUser() async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      print("User: $userCredential");
    } on FirebaseAuthException catch(e){
      print("Error: $e");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _login() async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      print("User: $userCredential");
      print("User: $_email");
      print("Password: $_password");
    } on FirebaseAuthException catch(e){
      print("Error: $e");
    } catch (e) {
      print("Error: $e");
    }
  }






  @override
  Widget build(BuildContext context) {

    var EmailFormInput = new InputWithIcon(icon: Icons.email, hint: "NTU Email.",  obscure: false, control: emailController, label: "NTU Email", passwordVisible: false, emailbutton: true);
    var PasswordFormInput = new InputWithIcon(icon: Icons.vpn_key, hint: "Enter password...",  obscure: true, control: passwordController, label: "Password", passwordVisible: true, emailbutton: false);
    var RegisterEmailFormInput = new InputWithIcon(icon: Icons.email, hint: "NTU Email",  obscure: false, control: emailController, label: "NTU Email", passwordVisible:false, emailbutton: true);
    var RegisterPasswordFormInput = new InputWithIcon(icon: Icons.vpn_key, hint: "Enter password...",  obscure: true, control: passwordController, label: "Password",passwordVisible: true, emailbutton: false);


    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    switch(_pageState){
      case 0:   // First Page
        _backgroundColor = Colors.white;
        _headingColor = Color(0xFFB189AB4);
        _loginYOffset = windowHeight;
        _registerYOffset = windowHeight;
        _loginXOffeset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        _headingTop = 100;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
      case 1: // Login Page
        _backgroundColor = Color(0xFFB189AB4);
        _headingColor = Colors.white;
        _loginYOffset = _keyboardVisible ? 40 : 270;
        _registerYOffset = windowHeight;
        _loginXOffeset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        _headingTop = 90;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
      case 2: // Sign Up
        _backgroundColor = Color(0xFFB189AB4);
        _headingColor = Colors.white;
        _loginYOffset = _keyboardVisible? 30 : 240;
        _registerYOffset = _keyboardVisible? 55 : 270;
        _loginXOffeset = 20;
        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;
        _headingTop = 80;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
    }



    return Stack(
      children: <Widget> [
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
              milliseconds: 1000
          ),
          color: _backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _pageState = 0;
                  });
                },
                child: Container(
                  // For the tile and description
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: _headingTop
                        ),
                        child: Text(
                          "Journaling",
                          style: TextStyle(
                              fontFamily: "Nunito",
                              color: _headingColor,
                              fontSize: 28
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(32),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20
                        ),
                        child: Text(
                          "Insert Description Here",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _headingColor,
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // This si to equlaise the padding on each side
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(
                    horizontal: 32
                ),
                child: Center(
                  child: Image.asset("assets/images/HealthyLifestylePoster.png"),
                ),
              ),
              Container( // Work as a wrapper for the bottom part of the layout
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      if(_pageState != 0){
                        _pageState = 0;
                      } else {
                        _pageState = 1;   // Which is the Login Page

                      }
                    });
                  },
                  child: Container( // Will contain actual button
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFB189AB4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          padding: EdgeInsets.all(32),
          width: _loginWidth,
          height: _loginHeight,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
              milliseconds: 1000
          ),
          transform: Matrix4.translationValues(_loginXOffeset,_loginYOffset,1),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_loginOpacity),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)
            ),
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("Login to continue",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                     EmailFormInput,

                    SizedBox(height: 20,),
                    PasswordFormInput,
                  ],
                ),
                Column(
                  children: <Widget> [
                    GestureDetector(
                      onTap: () {
                        /* showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('$_email'),
                            content:  Text('$_password'),
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
                        );*/
                        _login();
                      },
                      child: PrimaryButton(
                        buttonText: "Login",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 2;

                        });
                      },
                      child: OutlineButton(
                        buttonText: "Create new Account",
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          height: _registerHeight,
          padding: EdgeInsets.all(32),
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
              milliseconds: 1000
          ),
          transform: Matrix4.translationValues(0,_registerYOffset,1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)
            ),
          ),
          child:Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,   // Will validate on the go
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("Create a New Account",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                    RegisterEmailFormInput,
                    SizedBox(height: 20,),
                    RegisterPasswordFormInput
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){


                        if (_formKey.currentState.validate()){
                        // _formKey.currentState.save();     // If all data are correct, then save data to out variable
                          final message = 'Email: $_email\nPassword: $_password' ;
                          final snackBar = SnackBar(
                        content: Text(
                        message,
                        style: TextStyle(fontSize: 20),
                        ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);   // Will show up from the bottom
                          _createUser();
                        }
                        else{
                        setState(() {
                        _autoValidate = true;     // If all data are not valid then start auto validation.
                        });
                        }
                        }



                        //print("$_email and $_password");
                      ,
                      child: PrimaryButton(
                          buttonText: "Create Account"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 1;
                        });
                      },
                      child: OutlineButton(
                        buttonText: "Back to Login",
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

/*
 If need more rules on forms, Use nested For-loop
 */

// Form validation name (If needed)
// for regex testing: try https://regexr.com/
String validateName(String value){
  RegExp nameregex = new RegExp(r'[a-zA-Z]');
  if (!nameregex.hasMatch(value)){
    return 'Name must contain only alphabets';
  }
  else{
    return null;
  }
}

// Form validating email
String validateEmail(String value){
  RegExp emailregex = new RegExp(r'[a-zA-Z0-9]@e.ntu.edu.sg$');
  if (!emailregex.hasMatch(value)){
    return 'Email must end with @e.ntu.edu.sg';
  }
  else{
    return null;
  }
}
// Form validating password
String validatePassword(String value){
  RegExp passwordregex = new RegExp(r'[a-zA-Z0-9]');
  if (!passwordregex.hasMatch(value)){
    return 'Password can only be alphanumeric';
  }
  else{
    return null;
  }
}

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
   bool obscure;
  final TextEditingController control;
  final String label;
  final bool passwordVisible;
  final bool emailbutton;
  InputWithIcon({ this.icon,  this.hint,  this.obscure,  this.control,  this.label,  this.passwordVisible, this.emailbutton});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {


  /*
  TEXTFORMFIELD can have property maxlength
  */

  @override
  Widget build(BuildContext context) {
    if (widget.emailbutton){
      return Stack(
        children: <Widget>[
          Container(
            decoration:BoxDecoration(
              border: Border.all(
                  color: Color(0xFFBC7C7C7),
                  width: 2
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: <Widget>[
                Container(
                    width: 60,
                    child: Icon(
                        widget.icon,
                        size: 20,
                        color: Color(0xFFBB9B9B9))
                ),
                Expanded(
                    child: TextFormField(
                      validator: validateEmail,
                      controller: widget.control,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          border: InputBorder.none,
                          hintText: widget.hint
                      ),
                      obscureText: widget.obscure,
                    )
                )
                ,
              ],
            ),
          ),
        ],
      );
    }else{
      return Stack(
        children: <Widget>[
          Container(
            decoration:BoxDecoration(
              border: Border.all(
                  color: Color(0xFFBC7C7C7),
                  width: 2
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: <Widget>[
                Container(
                    width: 60,
                    child: Icon(
                        widget.icon,
                        size: 20,
                        color: Color(0xFFBB9B9B9))
                ),
                Expanded(
                    child: TextFormField(
                      validator: validatePassword,
                      controller: widget.control,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          border: InputBorder.none,
                          hintText: widget.hint
                      ),
                      obscureText: widget.obscure,
                    )
                )
                ,
                if (widget.passwordVisible) GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.obscure = !widget.obscure;
                    });

                  },
                    child: ToolTip(tool: Icons.help_rounded)) ,
              ],
            ),
          ),

        ],
      );
    }

  }
}

class ToolTip extends StatefulWidget {
  final IconData tool;

  ToolTip({ this.tool});

  @override
  _ToolTipState createState() => _ToolTipState();
}

class _ToolTipState extends State<ToolTip> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: "Just testing",
      child: Container(
          width: 40,
          child: Icon(
              widget.tool,
              size: 15,
              color: Color(0xFFBB9B9B9))
      )
    );
  }
}




class PrimaryButton extends StatefulWidget {

  final String buttonText;
  PrimaryButton({ this.buttonText});   // This is the class constructor

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFB189AB4),
          borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.all(20),
      child: Center(
          child: Text(
            widget.buttonText,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
          )
      ),
    );
  }
}





class OutlineButton extends StatefulWidget {
  final String buttonText;
  OutlineButton({ this.buttonText});   // This is the class constructor

  @override
  _OutlineButtonState createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFB189AB4),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.all(20),
      child: Center(
          child: Text(
            widget.buttonText,
            style: TextStyle(
                color: Color(0xFFB189AB4),
                fontSize: 16
            ),
          )
      ),
    );
  }
}








