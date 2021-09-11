import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewCategory extends StatefulWidget {
  NewCategory();
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final _titleController = TextEditingController();

  String getInitials(String text) {
    final sp = text.split(" ");
    String ret = "";
    sp.forEach((element) {
      ret += element.toUpperCase()[0];
    });
    return ret;
  }

  void _submitData(BuildContext ctx) async {
    if (_titleController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final categoryInitial = getInitials(enteredTitle);

    if (enteredTitle.isEmpty) {
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('categories').add({
        'category_name': enteredTitle,
        'category_initial': categoryInitial,
      });
    } on PlatformException catch (e) {
      var message = 'An error occured, could not add categories.';
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
    ScaffoldMessenger.of(ctx)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Category Added'),
            backgroundColor: Colors.green,
          ),
        );
    setState(() {
      Navigator.of(ctx).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(context),
              ),
              ElevatedButton(
                  child: Text("Add Category".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () => _submitData(context))
            ],
          ),
        ),
      ),
    );
  }
}
