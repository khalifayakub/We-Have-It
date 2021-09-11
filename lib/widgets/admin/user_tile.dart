import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  UserTile(this.email, this.username, this.userImage, {this.key});

  final String email;
  final String username;
  final String userImage;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(userImage),
        ),
        title: Text(
          username,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          email,
        ),
      ),
    );
  }
}
