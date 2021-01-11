import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'multistep/f1.dart';
import 'package:http/http.dart' as http;

import 'barcode/HomePage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "BarCode",
    home: HomePage(),
  ));
}
int _r;
Future<http.Response> createUser(String cn, String un, String p, String p2, String mail,
    String ic, String ut) async {


  var body=jsonEncode({
    "contactNumber": "7982825959",
    "userName": un,
    "pwdData": {"password": p, "confirmPassword": p2},
    "email": mail,
    "inviteCode": "ZEROVIR_C23456",
    "userType": ut
  });

  final String apiUrl = "https://app.lithion.in/V2/membership/apply";
  final response = await http.post(apiUrl, headers: {
    "Content-type": "application/json"
  }, body: body).then((http.Response response){
    print('response code is ${response.statusCode}');
    var res=jsonDecode(response.body);
    if(res['response_code']==200){
      _r=1;
    }
    else{
      _r=0;
    }
  });
}
//ZEROVIR_

class MyApp extends StatelessWidget {
  final TextEditingController contact = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  final TextEditingController pwd2 = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController invitecode = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: contact,
                  validator: (value){
                    if(value.isEmpty){
                      return 'enter some value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Contact No',
                    icon: Icon(Icons.contact_phone),
                  ),
                ),
                TextFormField(
                  controller: username,
                  validator: (value){
                    if(value.isEmpty){
                      return 'enter some value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Username',
                    icon: Icon(Icons.title),
                  ),
                ),
                TextFormField(
                  controller: pwd,
                  validator: (value){
                    if(value.isEmpty){
                      return 'enter some value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    icon: Icon(Icons.pages_sharp),
                  ),
                ),
                TextFormField(
                  controller: pwd2,
                  validator: (value){
                    if(value.isEmpty){
                      return 'enter some value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    icon: Icon(Icons.pages_sharp),
                  ),
                ),
                TextFormField(
                  controller: mail,
                  validator: (value){
                    if(value.isEmpty){
                      return 'enter some value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Mail',
                    icon: Icon(Icons.email),
                  ),
                ),
                TextFormField(
                  controller: invitecode,
                  validator: (value){
                    if(value.isEmpty){
                      return 'enter some value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Invite code',
                    icon: Icon(Icons.code),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      if(_formkey.currentState.validate()){
                        final String cn = contact.text;
                        final String un = username.text;
                        final String p = pwd.text;
                        final String p2 = pwd2.text;
                        final String m = mail.text;
                        final String i = invitecode.text;
                        final String userType = "ZEROVIR";
                        createUser(cn, un, p, p2, m, i, userType);
                        if(_r==0)
                        {
                          Toast.show("something went wrong", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        }else{
                          Toast.show("registered", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        }
                      }
                    },
                  ),
                )

              ],
            ),

          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     final String cn = contact.text;
      //     final String un = username.text;
      //     final String p = pwd.text;
      //     final String p2 = pwd2.text;
      //     final String m = mail.text;
      //     final String i = invitecode.text;
      //     final String userType = "ZEROVIR";
      //     createUser(cn, un, p, p2, m, i, userType);
      //     if(_r==0)
      //       {
      //         Toast.show("already registered", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      //       }else{
      //       Toast.show("registered", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      //     }
      //   },
      // ),
    );
  }
}
