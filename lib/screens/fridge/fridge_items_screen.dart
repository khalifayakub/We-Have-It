import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/fridge/fridge_item.dart';

class FridgeItemsScreen extends StatefulWidget {
  @override
  _FridgeItemsScreenState createState() => _FridgeItemsScreenState();
}

class _FridgeItemsScreenState extends State<FridgeItemsScreen> {
   final User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // <2> Pass `Future<QuerySnapshot>` to future
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            final user = snapshot.data;
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('fridge_items')
                  .where('userId',
                      whereIn: [user['uid'], user['fid']]).snapshots(),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final QuerySnapshot shoppingList = streamSnapshot.data;
                if (shoppingList.docs.isEmpty) {
                  return Center(
                    child: Text('No data'),
                  );
                }
                final list = shoppingList.docs;
                return ListView.builder(
                  reverse: false,
                  itemCount: list.length,
                  itemBuilder: (context, index) => FridgeItem(
                    list[index]['product_name'],
                    list[index]['product_initial'],
                    list[index]['product_category'],
                    list[index]['product_quantity'],
                    list[index]['quantity_type'],
                    list[index].id,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}