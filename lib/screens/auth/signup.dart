import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fridge_app/main.dart';
import 'package:fridge_app/widgets/auth/entry_field.dart';
import 'package:fridge_app/widgets/pickers/user_image_picker.dart';
import '../../widgets/auth/bezier_container.dart';
import './login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _username = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit(BuildContext ctx) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Please pick an image.',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      return;
    }
    UserCredential authResult;
    if (isValid) {
      _formKey.currentState.save();
      try {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: _userEmail.trim(), password: _userPassword.trim());

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${authResult.user.uid}.jpg');

        await ref.putFile(_userImageFile).whenComplete(() => null);

        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': _username.trim().toLowerCase(),
          'email': _userEmail.trim(),
          'image_url': url,
          'fid': 'null',
          'uid': authResult.user.uid
        });
      } on PlatformException catch (e) {
        var message = 'An error occured, please check your credentials.';
        if (e.message != null) {
          message = e.message;
        }
        ScaffoldMessenger.of(ctx)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(ctx).errorColor,
            ),
          );
      }
    }
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        _trySubmit(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'f',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ri',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'dge',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        EntryField(
          title: "Username",
          onSaved: (newValue) => {
            _username = newValue,
          },
          validator: (v) {
            if (v.isEmpty || v.length < 4) {
              return 'Please enter at least 4 characters';
            }
            return null;
          },
        ),
        EntryField(
          title: "Email",
          onSaved: (newValue) => {
            _userEmail = newValue,
          },
          validator: (v) {
            if (v.isEmpty || !v.contains('@')) {
              return 'Please enter a valid email address.';
            }
            return null;
          },
        ),
        EntryField(
          title: "Password",
          obsecure: true,
          onSaved: (newValue) => {
            _userPassword = newValue,
          },
          validator: (v) {
            if (v.isEmpty || v.length < 6) {
              return 'Password must be at least 6 characters long.';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),
                      UserImagePicker(_pickImage),
                      SizedBox(
                        height: 20,
                      ),
                      _emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      _submitButton(),
                      SizedBox(height: height * .14),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
