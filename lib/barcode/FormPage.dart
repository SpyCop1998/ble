import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
int _r;
Future<http.Response> createUser(String cn, String un, String p, String p2, String mail,
    String ic, String ut) async {
  var body=jsonEncode({
    "contactNumber": cn,
    "userName": un,
    "pwdData": {"password": p, "confirmPassword": p2},
    "email": mail,
    "inviteCode": ic,
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

class FormPage extends StatelessWidget {
  final TextEditingController contact = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  final TextEditingController pwd2 = TextEditingController();
  final TextEditingController mail = TextEditingController();

  // final TextEditingController invitecode = TextEditingController();
  final String userType = "ZEROVIR";
  final _formkey = GlobalKey<FormState>();
  String deviceName;

  FormPage(String k) {
    this.deviceName = k;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Device name - $deviceName',
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  TextFormField(
                    controller: username,
                    validator: (value){
                      if(value.isEmpty){
                        return 'enter some value';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'User Name',
                    ),
                  ),
                  TextFormField(
                    controller: contact,
                    validator: (value){
                      if(value.isEmpty){
                        return 'enter some value';
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: 'Contact No'),
                  ),
                  TextFormField(
                    controller: mail,
                    validator: (value){
                      if(value.isEmpty){
                        return 'enter some value';
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: pwd,
                    validator: (value){
                      if(value.isEmpty){
                        return 'enter some value';
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  TextFormField(
                    controller: pwd2,
                    validator: (value){
                      if(value.isEmpty){
                        return 'enter some value';
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: 'Confirm Password'),
                  ),
                  SizedBox(height: 50.0,),
                  Center(
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () async {
                        if(_formkey.currentState.validate()){
                          final String cn = contact.text;
                          final String un = username.text;
                          final String p = pwd.text;
                          final String p2 = pwd2.text;
                          final String m = mail.text;
                          final String i = deviceName;
                          final String userType = "ZEROVIR";
                          // createUser(String cn, String un, String p, String p2, String mail,
                          //     String ic, String ut)
                          createUser(cn,un,p,p2,m,deviceName,userType);
                          if(_r==1)
                          {
                            Toast.show("registered", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                          }else{
                            Toast.show("something went wrong", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                          }
                        }
                        contact.clear();
                        username.clear();
                        pwd.clear();
                        pwd2.clear();
                        mail.clear();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
