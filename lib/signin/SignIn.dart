
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/signin/api.dart';
import 'package:socialgamblingfront/signup/SignUp.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/util.dart';

class SignIn extends StatefulWidget {

  static final routeName = '/signin';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isDarkMode = false;




  @override
  initState(){

    super.initState();

  }


  Widget inputUserData(){
    return Center(
      child:Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(16),
            child: Image.asset("asset/images/logo.png",width: 100, height: 100,),),
            Padding(padding: EdgeInsets.only(bottom: 4),
              child: Text("Bloden",style: TextStyle( fontSize: 20),)),
            Padding(padding: EdgeInsets.all(16),
                child:   TextFormField(
                  autofillHints:const <String>[AutofillHints.username],
                  textAlign: TextAlign.center,
                  controller: usernameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre nom d'utilisateur";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(3.0, 25.0,),
                    focusedBorder: setOutlineBorder(3.0, 25.0),
                    border: setOutlineBorder(3.0, 25.0),
                    hintText: "Nom d'utilisateur",
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                autofillHints: const <String>[AutofillHints.password],
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrer un mot de passe";
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  focusedBorder: setOutlineBorder(3.0, 25.0),
                  enabledBorder: setOutlineBorder(3.0, 25.0),
                  border:setOutlineBorder(3.0, 25.0),
                  hintText: 'Mot de passe',
                ),
              ),)
            ,
            Padding(padding: EdgeInsets.all(12),
              child: ElevatedButton(
                style: BaseButtonRoundedColor(60,40,Colors.red[700]),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {

                    var result =  await signinUser(usernameController.text, passwordController.text);

                    if(result.code == 0){
                      final execute = await writeData(usernameController.text);
                      print(execute);
                      Navigator.pushReplacementNamed(context, TabView.routeName);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(result.message)),
                      );
                    }

                  }

                },
                child: Text('Se connecter'),
              ),),
             ElevatedButton(
                style: BaseButtonRoundedColor(60,40,Colors.red[700]),
                onPressed: ()  {
                      Navigator.pushNamed(context, SignUp.routeName);
                },
                child: Text("S'inscrire"),
              )
          ],
        ),

      ) ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(

        child: inputUserData()
      ),
      );
  }
}
