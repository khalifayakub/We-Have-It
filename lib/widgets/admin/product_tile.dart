import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String productName;
  final String productInitial;
  final String productId;
  final String productCategory;
  final Function deleteTx;
  final Key key;
  ProductTile(
      this.productName, this.productInitial, this.productCategory, this.productId, this.deleteTx,
      {this.key});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Are you sure?',
            ),
            content: Text(
              'Do you want to remove the product?',
            ),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          ),
        );
      },
      key: ValueKey(productId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteTx(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
      ),
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
                  child: Text(productInitial),
                ),
              ),
            ),
            title: Text(productName),
            subtitle: Text('Category: $productCategory'),
          ),
          padding: EdgeInsets.all(8),
        ),
      ),
    );
  }
}
