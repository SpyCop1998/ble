import 'package:ble/multistep/f2.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'f4.dart';

class f1 extends StatefulWidget {
  @override
  _f1State createState() => _f1State();
}

class _f1State extends State<f1> {
  bool focus = true;

  void _change() {
    setState(() {
      focus = false;
    });
  }

  final _formkey = GlobalKey<FormState>();

  final TextEditingController ic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("step1"),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: ic,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Some Value";
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Invite Code"),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                //sandeep
                child: Text("Next"),
                onPressed: () {
                  String i = ic.text;
                  if (i.length != 7) {
                    _onBasicAlert(context);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => f3(i)));
                  }
                  ic.clear();
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  _onBasicAlert(context) {
    Alert(
        context: context,
        title: "Error",
        desc: "Wrong Code, Enter again",
        buttons: [
          DialogButton(
            child: Text("Enter again"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]).show();
  }
}
