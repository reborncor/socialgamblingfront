import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:socialgamblingfront/model/ThemeModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/store/BlodenStoreCard.dart';
import 'package:socialgamblingfront/store/api.dart';
import 'package:socialgamblingfront/util/util.dart';

class BlodenStore extends StatefulWidget {
  static final routeName = '/store';

  @override
  _BlodenStoreState createState() => _BlodenStoreState();
}

class _BlodenStoreState extends State<BlodenStore> {

  TextEditingController searchController = new TextEditingController();

  int value = 0;
  int selectedAmount = 0;
  List<int> dens = [10,20,50,100];
  List<int> densPrice = [1,1,1,1];

  int userCurrentDens = 0;
  int userCurrentDateOfBan = 0;
  bool isDarkMode = false;

  ThemeModel themeNotifier;
  CardEditController editController;

  @override
  initState() {
    fetchData();
    super.initState();
  }

  stripePayment(int value){
   if(value != 0){
   }

  }

  fetchData() async{

    String response = await getCurrentUserMoney();
    String responseDateOfban = await getCurrentUserDateOfban();

    setState(() {
      userCurrentDens = int.parse(response);
      userCurrentDateOfBan = int.parse(responseDateOfban);
    });
  }
  callBack(value,amount){
    setState(() {
      this.value = value;
      this.selectedAmount = amount;

    });
  }
  Widget listOfDensToBuy(){
    return  Expanded(child:  ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount :dens.length,
        itemBuilder: (context, index) {
          return BlodenStoreCard(value : dens[index],price: densPrice[index], callBack:callBack);
        })
    );
  }

  buyDensForUser(int amount,bool isCredit) async {
    BasicResponse result = await buyDens(amount, isCredit);
    if(result.code == SUCCESS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
      setState(()  {
        userCurrentDens = userCurrentDens + amount;
        userCurrentDateOfBan = int.parse(result.payload['dateOfBan'].toString());
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  refundDensUser(int amount) async {

    BasicResponse result = await refundMoney(amount);
    if(result.code == SUCCESS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
      setState(()  {
        userCurrentDens = userCurrentDens - amount;
        userCurrentDateOfBan = 0;
        setUserData("dateOfBan", userCurrentDateOfBan.toString());
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  Widget showCreditDialog(BuildContext context) {
    return new AlertDialog(
      title: Text("Aide de la banque"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Vous disposez de moins de 10 Dens et vous risquez de vous faire bannir de l'application, effectuez un credit et obtenez 50 Dens que vous pouvez rembourser sous 24h !", style:TextStyle(color : themeNotifier.isDark ? Colors.white : Colors.black),),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        ElevatedButton(
          style: BaseButtonRoundedColor(60,40,Colors.red[700]),
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text("Fermer",style: TextStyle(color: Colors.black),),
        ),
        ElevatedButton(
          style: BaseButtonRoundedColor(60,40,Colors.amber),
          onPressed: () async {
            buyDensForUser(50, true);
            Navigator.pop(context);
          },
          child: Text("Effectuer un crédit !",style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }

   Future<void> makePayment(int amount) async{
    final result = await buyDensStripe(amount);

    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: result.payload["paymentIntent"],
      applePay: Stripe.instance.isApplePaySupported.value,
      googlePay: true,
      style: isDarkMode ?  ThemeMode.light : ThemeMode.dark,
      testEnv: true,
      merchantCountryCode: 'FR',
      merchantDisplayName: 'Bloden',
    ));
    setState(() {
    });
    displayPaymentStripe(result.payload["paymentIntent"]);
  }

  Future<void> displayPaymentStripe(clientSecret) async {
    try{
    // editControl
    // await Stripe.instance.createPaymentMethod(PaymentMethodParams.card());
    await Stripe.instance.presentPaymentSheet();
        setState(() {

        });
        await Stripe.instance.retrievePaymentIntent(clientSecret).then((value) =>{
          if(value.status == PaymentIntentsStatus.Succeeded){
            buyDensForUser(this.value, false)
          }
        });
    }catch(e){
      log("ERREUR");
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, ThemeModel themeNotifier, child) {
      this.themeNotifier = themeNotifier;

      return new Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
            ),
            backgroundColor: Colors.red[700] ,
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: InkWell(child: (userCurrentDateOfBan != 0 ? Row( children: [
                    IconButton(icon : Icon(Icons.store , size: 30,),color: Colors.black, onPressed: () async {
                      refundDensUser(50);
                    },),
                    Text("Remboursement", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),)
                  ]
                  ) : SizedBox.fromSize(size: Size(1,1))),onTap: (){
                    refundDensUser(50);
                  }

                    ,)
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: InkWell(child:  Row( children: [
                    Icon(Icons.monetization_on_outlined, size: 30,color: Colors.black,),
                    Text(userCurrentDens.toString()+' Dens', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),)
                  ]
                  ),onTap: (){
                    if(userCurrentDens < 10 ){
                      showDialog(context: context, builder:(context) => showCreditDialog(context));

                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Vous ne pouvez pas réaliser de crédit pour le moment")),
                      );
                    }
                  },)
              ),

              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      try{
                        final data = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Setting()),
                        );
                        setState(() {
                          isDarkMode = data as bool;
                        });
                      }catch(e){
                        fetchData();
                      }


                    },
                    child: Icon(
                      Icons.account_circle,color: Colors.black,size: 30,
                    ),
                  )
              ),
            ],
            title: Text("Boutique",style: TextStyle(color: Colors.black)),
          ),
          body: Container(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                listOfDensToBuy(),

                ElevatedButton(
                    style: BaseButtonRoundedColor(60,40,Colors.red[700]),
                    onPressed: () async {
                      if(value!=0){
                        await makePayment(this.selectedAmount*100);
                      }

                      },
                    child: Text('Acheter Maintenant : $value'))
              ],
            ),
          )
      );
    },);
  }
}


