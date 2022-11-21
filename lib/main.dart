import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_login_ui/screens/Info.dart';
import './models/auth.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            dividerColor: Colors.transparent
        ),
        routes: {
          '/': (context) => Login(),
          '/info': (context) => MenuScreen()
        },
        initialRoute: '/',
      ),
    );
  }
}



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void login(BuildContext context, Auth auth, String email, password) async{
    try{
      var url = "https://devapi.adscompass.ru/api/v1/auth/token?email=" + email + "&password=" + password;
      Response response = await post(
          Uri.parse(url),
          headers: {
            'x-referer' : "https://dev.adscompass.ru",
          }
      );
      print(response.statusCode);
      if(response.statusCode == 201){
        debugPrint('Login successfully');
        var data = jsonDecode(response.body.toString());
        var token = data["data"]["token"];
        debugPrint(token);

        Response response2 = await get(
            Uri.parse("https://devapi.adscompass.ru/api/v1/profile"),
            headers: {
              'x-referer' : "https://dev.adscompass.ru",
              'Authorization' : token.toString(),
              "x-mobile-app" : "DEV"
            }
        );
        if(response2.statusCode == 200){
          var data = jsonDecode(response2.body.toString());
          var name = data["data"]["name"];
          var id = data["data"]["id"];
          var email = data["data"]["email"];
          debugPrint(name.toString());
          Navigator.pushNamed(context, "/info");
          final storage = new FlutterSecureStorage();
          // await storage.write(key: "auth_token", value: token.toString());
          auth.setAuthData(name: name, email: email, id: id.toString(), token: token.toString());

        }
        else{
          debugPrint('failed2');
        }
      }else {
        Fluttertoast.showToast(
            msg: "Неверный логин или пароль",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: "Плохое интернет-соединение",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "assets/login.png",
                  height: 250,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Email",
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.grey[100],
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Email',
                        contentPadding: EdgeInsets.all(10)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Text(
                  "Password",
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.grey[100],
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        contentPadding: EdgeInsets.all(10)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  color: Colors.red[800],
                  height: 20,
                  minWidth: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.white)),
                  onPressed: () {
                    login(context, auth,emailController.text.toString(), passController.text.toString());

                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),

                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
