import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/screens/admin/category_screen.dart';
import 'package:fridge_app/screens/admin/product_screen.dart';
import 'package:fridge_app/screens/admin/user_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, Object>> _pages;
  @override
  void initState() {
    _pages = [
      {
        'page': UserScreen(),
        'title': 'Users',
      },
      {
        'page': ProductScreen(),
        'title': 'Products',
      },
      {
        'page': CategoryScreen(),
        'title': 'Categories',
      },
    ];
    super.initState();
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
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
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
            icon: Icon(Icons.supervised_user_circle),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.apps_rounded),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
      ),
    );
  }
}