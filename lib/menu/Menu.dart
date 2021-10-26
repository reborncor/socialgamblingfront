import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/util/util.dart';

class Menu extends StatefulWidget {
   static final routeName = '/menu';

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  TextEditingController searchController = new TextEditingController();

  Widget headerApp(){
    return Container(
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(fixedSize: Size(150,30)), child: Text('Amis'),),
        ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(fixedSize: Size(150,30)), child: Text('Chat'),)

      ],
     ),
    );
  }
  Widget searchFriend(){
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Search",
        suffixIcon: InkWell(
          onTap: () => searchController.clear(),
          child: Icon(Icons.search),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: Text('Drawer !'),
        )
      ),
      appBar: AppBar(
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.account_circle
                ),
              )
          ),
        ],
        title: Text("Menu"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          headerApp(),
          searchFriend(),
          Center(

              child: Text('Menu')
          ),
        ],
      )
    );
  }
}
