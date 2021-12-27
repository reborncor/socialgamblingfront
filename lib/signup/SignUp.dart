import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialgamblingfront/model/ThemeModel.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/signin/api.dart';
import 'package:socialgamblingfront/signup/api.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {

  static final routeName = '/signup';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ThemeModel themeNotifier;




  Widget inputUserData(){
      return Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.all(8),child: Text("Inscrivez vous !",style: TextStyle( color: themeNotifier.isDark ? Colors.white : Colors.black,fontWeight: FontWeight.bold, fontSize: 18),),),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),
                  controller: usernameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre nom d'utilisateur";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(3.0, 25.0),
                    focusedBorder: setOutlineBorder(3.0, 25.0),
                    border: setOutlineBorder(5.0, 25.0),
                    hintText: 'Username',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),
                  controller: lastNameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre nom";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(3.0, 25.0),
                    focusedBorder: setOutlineBorder(3.0, 25.0),
                    border: setOutlineBorder(5.0, 25.0, ),
                    hintText: 'Nom',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),
                  controller: firstNameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre prénom";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(3.0, 25.0, ),
                    focusedBorder: setOutlineBorder(3.0, 25.0, ),
                    border: setOutlineBorder(5.0, 25.0, ),
                    hintText: 'Prénom',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),
                  controller: emailController,
                  validator:(value) {
                    final bool isValid = EmailValidator.validate(value);
                    if(!isValid){
                      return "Adresse email incorrecte";
                    }
                    if (value == null || value.isEmpty) {
                      return "Entre votre adresse email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(3.0, 25.0, ),
                    focusedBorder: setOutlineBorder(3.0, 25.0, ),
                    border: setOutlineBorder(5.0, 25.0, ),
                    hintText: 'Adresse email',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),
                  controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entrer votre numéro de téléphone";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(3.0, 25.0, ),
                    focusedBorder: setOutlineBorder(3.0, 25.0, ),
                    border: setOutlineBorder(5.0, 25.0, ),
                    hintText: 'Numéro de téléphone',
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),
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
                  focusedBorder: setOutlineBorder(3.0, 25.0, ),
                  enabledBorder: setOutlineBorder(3.0, 25.0, ),
                  border:setOutlineBorder(5.0, 25.0, ),
                  hintText: 'Password',
                ),
              ),)
            ,
            Padding(padding: EdgeInsets.all(12),
              child: ElevatedButton(
                style: BaseButtonRoundedColor(60,40,Colors.red[700]),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {

                    UserModel user = UserModel.forJson(email: emailController.text, firstName: firstNameController.text,
                    lastName: lastNameController.text, password: passwordController.text, phoneNumber: phoneNumberController.text,
                    username: usernameController.text);

                    var result =  await signUpUser(user);

                    if(result.code ==  0){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                      Navigator.pushNamed(context, SignIn.routeName);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    }

                  }

                },
                child: Text("S'inscrire"),
              ),),

          ],
        ),

      ) ;

  }


  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        this.themeNotifier = themeNotifier;
      return Scaffold(



          body: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: inputUserData(),
              )
          )
      );
    },);
  }
}
