import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/fridge/fridge_user_tile.dart';

class PersonItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users').where('fid', isEqualTo: user.uid)
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final users = streamSnapshot.data.docs;
            return ListView.builder(
              reverse: false,
              itemCount: users.length,
              itemBuilder: (context, index) => FridgeUserTile(
                users[index]['email'],
                users[index]['username'],
                users[index]['image_url'],
                users[index].id,
                key: ValueKey(
                  users[index].id,
                ), // for efficient/foolproof updating the list
              ),
            );
          },
        );
  }
}