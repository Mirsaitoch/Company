import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);
  void logout(BuildContext context,Auth auth){
    auth.wipeAuthData();
    Navigator.pushNamed(context, "/");
  }
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    var authData = auth.auth_data;
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
        backgroundColor: Colors.red[400],
          automaticallyImplyLeading: false
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20,15,20,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red[400],
                child: Text("SA",style: TextStyle(color:Colors.white ),),
              ),
              SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Уникальный идентификатор", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),),
                  SizedBox(width: 20,),
                  Text(authData['id'].toString()),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Email", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                  SizedBox(width: 20,),
                  Text(authData['email'].toString()),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Имя", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                  SizedBox(width: 20,),
                  Text(authData['name'].toString()),
                ],
              ),
              SizedBox(height: 20,),
              MaterialButton(
                color: Colors.red[400],
                height: 20,
                minWidth: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.white)),
                onPressed: ()=>logout(context, auth),
                child: Text(
                  "Выход",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),

              ),
            ],
          ),
        )
      ),
    );
  }
}
