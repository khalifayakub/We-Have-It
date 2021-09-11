import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final String productName;
  final String productInitial;
  final String productId;
  final String productCategory;
  final String quantityType;
  ProductItem(
    this.productName,
    this.productInitial,
    this.productCategory,
    this.quantityType,
    this.productId,
  );

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
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
              "Add To Fridge",
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
      color: Colors.yellow,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.add_shopping_cart,
              color: Colors.red,
            ),
            Text(
              "Add To Shopping List",
              style: TextStyle(
                color: Colors.red,
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
                            .collection('users')
                            .where('uid', isEqualTo: currentUser.uid)
                            .get()
                            .then((value) => {
                                  FirebaseFirestore.instance
                                      .collection('fridge_items')
                                      .where('product_name',
                                          isEqualTo: widget.productName)
                                      .where('userId', whereIn: [
                                        value.docs[0]['uid'],
                                        value.docs[0]['fid']
                                      ])
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
                                                  'product_name':
                                                      widget.productName,
                                                  'product_initial':
                                                      widget.productInitial,
                                                  'product_category':
                                                      widget.productCategory,
                                                  'product_quantity': quantity,
                                                  'quantity_type':
                                                      widget.quantityType,
                                                }),
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Item added to Fridge.'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                )
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Item already in fridge.'),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .errorColor,
                                                  ),
                                                )
                                              }
                                          }),
                                });

                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                );
              });
          return false;
        } else {
          final currentUser = FirebaseAuth.instance.currentUser;
          final bool res = false;
          await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: currentUser.uid)
              .get()
              .then((value) => {
                    print('Here, After UID GET'),
                    FirebaseFirestore.instance
                        .collection('shopping_list')
                        .where('product_name', isEqualTo: widget.productName)
                        .where('userId', whereIn: [
                          value.docs[0]['uid'],
                          value.docs[0]['fid']
                        ])
                        .limit(1)
                        .get()
                        .then((value) => {
                              print('Here, After checking product exists'),
                              if (value.docs.length == 0)
                                {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .where('uid', isEqualTo: currentUser.uid)
                                      .get()
                                      .then((value) => {
                                            FirebaseFirestore.instance
                                                .collection('fridge_items')
                                                .where('product_name',
                                                    isEqualTo:
                                                        widget.productName)
                                                .limit(1)
                                                .get()
                                                .then((value) => {
                                                      if (value.docs.length ==
                                                          0)
                                                        {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'shopping_list')
                                                              .add({
                                                            'userId':
                                                                currentUser.uid,
                                                            'product_name':
                                                                widget
                                                                    .productName,
                                                            'product_initial':
                                                                widget
                                                                    .productInitial,
                                                            'product_category':
                                                                widget
                                                                    .productCategory,
                                                            'quantity_type':
                                                                widget
                                                                    .quantityType,
                                                          }),
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Item added to shopping list.'),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ),
                                                          )
                                                        }
                                                      else
                                                        {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Item already in fridge.'),
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .errorColor,
                                                            ),
                                                          )
                                                        }
                                                    }),
                                          }),
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Item already in shopping list.'),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ),
                                  )
                                }
                            })
                  });

          return res;
        }
      },
    );
  }
}
