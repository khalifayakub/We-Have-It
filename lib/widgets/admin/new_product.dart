import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewProduct extends StatefulWidget {
  NewProduct();
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _titleController = TextEditingController();
  final _catController = TextEditingController();
  final _quantityType = TextEditingController();
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
    if (_catController.text.isEmpty) {
      return;
    }
    final enteredCategory = _catController.text;
     if (_quantityType.text.isEmpty) {
      return;
    }
    final enteredQuantityType = _quantityType.text;
    if (enteredTitle.isEmpty) {
      return;
    }
    if (enteredCategory.isEmpty) {
      return;
    }
    if (enteredQuantityType.isEmpty) {
      return;
    }
    final productInitial = getInitials(enteredTitle);
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'product_name': enteredTitle,
        'product_initial': productInitial,
        'product_category': enteredCategory,
        'quantity_type': enteredQuantityType
      });
    } on PlatformException catch (e) {
      var message = 'An error occured, could not add product.';
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
            content: Text('Product Added'),
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
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Quantity Type'),
                controller: _quantityType,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Category'),
                controller: _catController,
                onSubmitted: (_) => _submitData(context),
              ),
              ElevatedButton(
                  child: Text("Add Product".toUpperCase(),
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
