import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/fridge/person_item.dart';

class AddPersonScreen extends StatefulWidget {
  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  String username = '';
  final _textFieldController = TextEditingController();
  String valueText = '';
  Future<void> _addUser() async {
    final user = FirebaseAuth.instance.currentUser;
    username = valueText.toLowerCase();
    if (username.isEmpty) {
      return;
    }
    String message = '';
    await FirebaseFirestore.instance
        .collection('users')
        .where('fid', isEqualTo: user.uid)
        .get()
        .then((value) => {
              if (value.docs.length <= 5)
                {
                  FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isEqualTo: username)
                      .limit(1)
                      .get()
                      .then((value) => {
                            if (value.docs[0]['uid'] == user.uid || value.docs[0]['fid'] == user.uid)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'You can not add user to fridge again'),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              }
                            else if (value.docs.length == 1)
                              {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(value.docs[0]['uid'])
                                    .update({
                                  'fid': user.uid,
                                }),
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({
                                  'fid': value.docs[0]['uid'],
                                }),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'User Added'),
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              }
                            else
                              {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'User does not exist'),
                                    backgroundColor: Colors.red,
                                  ),
                                ),}
                          })
                }
              else
                {  ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Can not add more than 4 users'),
                                    backgroundColor: Colors.red,
                                  ),
                                ),}
            });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add User to Fridge'),
        ),
        body: Container(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textFieldController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: InputDecoration(labelText: 'Enter Username'),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                      Icons.add,
                    ),
                    onPressed: valueText.trim().isEmpty ? null : _addUser,
                  )
                ],
              ),
            ),
            Expanded(
              child: PersonItem(),
            )
          ],
        )));
  }
}
