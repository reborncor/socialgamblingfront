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
                Container(
                  height :80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.none,
                      image: AssetImage('asset/images/treasure-opened.png'),
                    ),
                  ),
                ),
                ListTile(

                  title:  Text(widget.value.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),),
                  subtitle:  Text("Pack dens classique",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],
            )
        ),
      ),);
  }
}
