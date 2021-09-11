import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShoppingListItem extends StatefulWidget {
  final String productName;
  final String productInitial;
  final String productId;
  final String productCategory;
  final String quantityType;
  ShoppingListItem(
    this.productName,
    this.productInitial,
    this.productCategory,
    this.quantityType,
    this.productId,
  );
  @override
  _ShoppingListItemState createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  final _textFieldController = TextEditingController();
  String valueText;
  int quantity;
  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            Text(
              "Bought",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Remove from Shopping List",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.productId),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(widget.productInitial),
                ),
              ),
            ),
            title: Text(widget.productName),
            subtitle: Text('Category: ${widget.productCategory}'),
          ),
          padding: EdgeInsets.all(8),
        ),
      ),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final bool res = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Enter the quantity'),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        valueText = value;
                      });
                    },
                    controller: _textFieldController,
                    decoration: InputDecoration(
                        hintText: "Quantity in ${widget.quantityType}"),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text('CANCEL'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text('OK'),
                      onPressed: () async {
                        quantity = int.parse(valueText);
                        final currentUser = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance
                            .collection('fridge_items')
                            .where('product_name',
                                isEqualTo: widget.productName)
                            .limit(1)
                            .get()
                            .then((value) => {
                                  _textFieldController.clear(),
                                  if (value.docs.length == 0)
                                    {
                                      FirebaseFirestore.instance
                                          .collection('fridge_items')
                                          .add({
                                        'userId': currentUser.uid,
                                        'product_name': widget.productName,
                                        'product_initial':
                                            widget.productInitial,
                                        'product_category':
                                            widget.productCategory,
                                        'product_quantity': quantity,
                                        'quantity_type': widget.quantityType,
                                      }),
                                      FirebaseFirestore.instance
                                          .collection('shopping_list')
                                          .doc(widget.productId)
                                          .delete(),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Item added to Fridge.'),
                                          backgroundColor:
                                              Colors.green,
                                        ),
                                      )
                                    }
                                  else
                                    {
                                     
                                      FirebaseFirestore.instance
                                          .collection('shopping_list')
                                          .doc(widget.productId)
                                          .delete(),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Item already in Fridge.'),
                                          backgroundColor:
                                              Colors.green,
                                        ),
                                      )
                                    }
                                });
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                );
              });
          return true;
        } else {
          final bool res = true;
         await FirebaseFirestore.instance
              .collection('shopping_list')
              .doc(widget.productId)
              .delete().then((value) => {
                 ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item removed from shopping list.'),
              backgroundColor: Theme.of(context).errorColor,
            ),
          ),
              });
          return res;
        }
      },
    );
  }
}
