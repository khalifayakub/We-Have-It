import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FridgeUserTile extends StatefulWidget {
  FridgeUserTile(this.email, this.username, this.userImage, this.userId,
      {this.key});

  final String email;
  final String username;
  final String userImage;
  final String userId;
  final Key key;

  @override
  _FridgeUserTileState createState() => _FridgeUserTileState();
}

class _FridgeUserTileState extends State<FridgeUserTile> {
  Future<void> removeUser(BuildContext ctx) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .where('fid', isEqualTo: user.uid)
        .get()
        .then((value) => {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.docs[0]['uid'])
                  .update({
                'fid': 'null',
              }),
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({
                'fid': 'null',
              }),
            });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User Removed'),
        backgroundColor: Colors.green,
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
              "Remove User",
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
        key: Key(widget.userId),
        child: Card(
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 15,
          ),
          child: Padding(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.userImage),
              ),
              title: Text(widget.username),
              subtitle: Text(widget.email),
            ),
            padding: EdgeInsets.all(8),
          ),
        ),
        background: slideLeftBackground(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final bool res = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Remove User'),
                  content: Text('Are you sure you want to remove user?'),
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
                        removeUser(context);
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                );
              },
            );
          }
          return true;
        });
  }
}
