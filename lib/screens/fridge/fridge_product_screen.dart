import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/fridge/category_item.dart';

class FridgeProductScreen extends StatefulWidget {
  @override
  _FridgeProductScreenState createState() => _FridgeProductScreenState();
}

class _FridgeProductScreenState extends State<FridgeProductScreen> {
  int index = 0;
  static const color = const [
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.blue,
    Colors.green
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .orderBy('category_name', descending: false)
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final categories = streamSnapshot.data.docs;
        return GridView.builder(
          reverse: false,
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
          itemCount: categories.length,
          itemBuilder: (context, index) => CategoryItem(
            categories[index].id,
            categories[index]['category_name'],
            color[index++],
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 50,
          ),
        );
      },
    );
  }
}
