import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/admin/user_tile.dart';

class UserScreem extends StatelessWidget {
  
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users').where('email', isNotEqualTo: user.email)
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
              itemBuilder: (context, index) => UserTile(
                users[index]['email'],
                users[index]['username'],
                users[index]['image_url'],
                key: ValueKey(
                  users[index].id,
                ), // for efficient/foolproof updating the list
              ),
            );
          },
        );
  }
}