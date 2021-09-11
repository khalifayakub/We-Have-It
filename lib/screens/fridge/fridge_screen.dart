import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fridge_app/helpers/firebase_notification_handler.dart';
import 'package:fridge_app/screens/fridge/add_person_screen.dart';
import 'package:fridge_app/screens/fridge/fridge_items_screen.dart';
import 'package:fridge_app/screens/fridge/fridge_product_screen.dart';
import 'package:fridge_app/screens/fridge/shopping_list_screen.dart';

class FridgeScreen extends StatefulWidget {
  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  List<Map<String, Object>> _pages;
  FirebaseNotifications firebaseNotifications = new FirebaseNotifications();
  @override
  void initState() {
    _pages = [
      {
        'page': FridgeProductScreen(),
        'title': 'Products',
      },
      {
        'page': FridgeItemsScreen(),
        'title': 'Fridge',
      },
      {
        'page': ShoppingListScreen(),
        'title': 'Shopping List',
      },
    ];
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('Setting up notification');
      firebaseNotifications.setupFirebase(context);
    });

  }

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.supervised_user_circle, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Add User'),
                    ],
                  ),
                ),
                value: 'adduser',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
              if (itemIdentifier == 'adduser') {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPersonScreen()));
              }
            },
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.apps_rounded),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.ac_unit),
            label: 'Fridge',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.add_shopping_cart),
            label: 'Shopping List',
          ),
        ],
      ),
    );
  }
}
