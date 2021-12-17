import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlodenStoreCard extends StatefulWidget {
  final int value;
  Function callBack;
  BlodenStoreCard({this.value, this.callBack});

  @override
  _BlodenStoreCardState createState() => _BlodenStoreCardState();
}

class _BlodenStoreCardState extends State<BlodenStoreCard> {


  @override
  Widget build(BuildContext context) {
    return new Padding(padding: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          widget.callBack(widget.value);
        },
        child: Card(
            elevation: 10,
            color: Colors.red[700],
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(50),
            ) ,

            child:  Column(
              children: [
                Image(image: AssetImage("asset/images/donkeykong.jpg")),
                ListTile(

                  title:  Text(widget.value.toString()),
                  subtitle:  Text("Pack dens classique"),
                ),
              ],
            )
        ),
      ),);
  }
}
