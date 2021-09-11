import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/fridge/product_item.dart';

class AddProductScreen extends StatefulWidget {
  final String categoryName;
  AddProductScreen(this.categoryName);
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('product_category', isEqualTo: widget.categoryName)
            .orderBy('product_name', descending: false)
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final products = streamSnapshot.data.docs;

          return ListView.builder(
            reverse: false,
            itemCount: products.length,
            itemBuilder: (context, index) => ProductItem(
              products[index]['product_name'],
              products[index]['product_initial'],
              products[index]['product_category'],
              products[index]['quantity_type'],
              products[index].id,
            ),
          );
        },
      ),
    );
  }
}
