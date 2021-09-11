import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/admin/new_product.dart';
import 'package:fridge_app/widgets/admin/product_tile.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  void _startAddNewProduct(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewProduct(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteProduct(String id) {
    FirebaseFirestore.instance.collection("products").doc(id).delete();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(height: 20),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .orderBy('product_name', descending: false)
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final products = streamSnapshot.data.docs;
            if (products.length == 0) {
              return Center(
                child: Text("No Product added"),
              );
            }
            return ListView.builder(
              reverse: false,
              itemCount: products.length,
              itemBuilder: (context, index) => ProductTile(
                products[index]['product_name'],
                products[index]['product_initial'],
                products[index]['product_category'],
                products[index].id,
                _deleteProduct,
                key: ValueKey(
                  products[index].id,
                ), // for efficient/foolproof updating the list
              ),
            );
          },
        ),
        Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.80,
            child: ElevatedButton(
        style: ElevatedButton.styleFrom(
           shape: CircleBorder(), 
           primary: Colors.red
        ),
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Icon(Icons.add)
        ),
        onPressed: () => _startAddNewProduct(context),
),),
      ],
    );
  }
}
