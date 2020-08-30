import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../screens/add_status.dart';
import '../screens/all_status_screen.dart';
import '../screens/my_status_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentPage = 0;
  var _page = [
    AllStatusScreen(),
    MyStatusScreen(),
    Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.grey[850],
        selectedLabelStyle: TextStyle(
          color: Colors.yellow,
        ),
        unselectedLabelStyle: TextStyle(color: Colors.white),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.grey[850],
            icon: Icon(Icons.public),
            title: Text("Feed"),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey[850],
            icon: Icon(Icons.data_usage),
            title: Text("My Status"),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey[850],
            icon: Icon(Icons.power_settings_new),
            title: Text("Log Out"),
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Provider.of<AuthProvider>(context, listen: false).logOut();
          }
          setState(() {
            _currentPage = index;
          });
        },
      ),
      floatingActionButton: Visibility(
        visible: _currentPage == 1,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddStatusScree.routeName);
            },
            child: Icon(
              Icons.add,
              color: Colors.black,
            )),
      ),
    );
  }
}
