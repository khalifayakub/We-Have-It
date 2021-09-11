import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/admin/new_category.dart';
import 'package:fridge_app/widgets/admin/category_tile.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  void _startAddNewCategory(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewCategory(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteCategory(String id) {
    FirebaseFirestore.instance.collection("categories").doc(id).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(height: 20),
        StreamBuilder(
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
            if (categories == []) {
              return Center(
                child: Text("No category added"),
              );
            }
            return ListView.builder(
              reverse: false,
              itemCount: categories.length,
              itemBuilder: (context, index) => CategoryTile(
                categories[index]['category_name'],
                categories[index]['category_initial'],
                categories[index].id,
                _deleteCategory,
                key: ValueKey(
                  categories[index].id,
                ), 
              ),
            );
          },
        ),
        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width * 0.80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), primary: Colors.red),
            child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Icon(Icons.add)),
            onPressed: () => _startAddNewCategory(context),
          ),
        ),
      ],
    );
  }
}
