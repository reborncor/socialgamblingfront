import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Widget inputUserData(){
      return Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  controller: usernameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre nom d'utilisateur";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    border: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    hintText: 'Username',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  controller: lastNameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre nom";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    border: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    hintText: 'Nom',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  controller: firstNameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre prénom";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    border: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    hintText: 'Prénom',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
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
                    enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    border: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    hintText: 'Adresse email',
                  ),
                )),
            Padding(padding: EdgeInsets.all(8),
                child:   TextFormField(
                  controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entrer votre numéro de téléphone";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    border: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    hintText: 'Numéro de téléphone',
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
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
                  focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                  enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                  border:setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                  hintText: 'Password',
                ),
              ),)
            ,
            Padding(padding: EdgeInsets.all(12),
              child: ElevatedButton(
                style: BaseButtonRoundedColor(60,40,Colors.amber[300]),
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

    return Scaffold(
//      appBar: AppBar(
//         backgroundColor: Colors.amber[300],
//        title: Text("Connexion utilisateur"),
//      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: inputUserData(),
        )
      )
    );
  }
}
