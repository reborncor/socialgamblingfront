/// Flutter code sample for BottomNavigationBar


import 'package:flutter/material.dart';
import 'package:socialgamblingfront/chatlist/ChatList.dart';
import 'package:socialgamblingfront/friendlist/FriendList.dart';
import 'package:socialgamblingfront/menu/Menu.dart';
import 'package:socialgamblingfront/store/BlodenStore.dart';

import '../util/util.dart';

/// This is the stateful widget that the main application instantiates.
class TabView extends StatefulWidget {
  const TabView({Key key}) : super(key: key);
  static const routeName = '/tabview';

  @override
  State<TabView> createState() => _TabViewState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _TabViewState extends State<TabView> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    FriendList(),
    Menu(),
    BlodenStore(),
    ChatList(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }
  fetchData(){

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amis',
            backgroundColor: Colors.red[700],

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Jeux',
            backgroundColor: Colors.red[700],

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Boutique',
            backgroundColor: Colors.red[700],

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
            backgroundColor: Colors.red[700],

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        backgroundColor: Colors.red[700],
        unselectedItemColor: Colors.red[50],
        onTap: _onItemTapped,
      ),
    );
  }
}
