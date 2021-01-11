import 'package:ble/multistep/f4.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'f3.dart';

String _inviteCode;

class f3 extends StatefulWidget {
  f3(String i) {
    _inviteCode = i;
  }

  @override
  _f3State createState() => _f3State();
}

class _f3State extends State<f3> {
  bool bt = true;

  void _hideB() {
    setState(() {
      bt = false;
    });
  }

  void _showB() {
    setState(() {
      bt = true;
    });
  }

  bool focus = true;

  void _change() {
    setState(() {
      focus = false;
    });
  }

  void _changef() {
    setState(() {
      focus = true;
    });
  }

  bool isShowT = false;

  void _changeV() {
    setState(() {
      isShowT = true;
    });
  }

  void _hide() {
    setState(() {
      isShowT = false;
    });
  }

  Position currentLocation;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController ic = TextEditingController();

  final TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("step2"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  enabled: focus,
                  controller: ic,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Some Value";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Mail"),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: bt,
                  child: ElevatedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      String mail = ic.text;
                      final bool isValid = EmailValidator.validate(mail);
                      if (mail.isNotEmpty && isValid) {
                        Toast.show("Email is ok", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                        _changeV();
                        _change();
                        // _hide();
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>f3()));
                        _hideB();
                      } else {
                        _onBasicAlert(context);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: isShowT,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: otp,
                        validator: (value) {
                          if (value == null) {
                            return "Enter some value";
                          }
                          return null;
                        },
                        decoration: InputDecoration(hintText: "OPT"),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ElevatedButton(
                        child: Text("Next"),
                        onPressed: () async {
                          String OTP = "0000";
                          String inputOTP = otp.text;
                          if (inputOTP == OTP && ic.text.isNotEmpty) {
                            // locateUser();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        f2(_inviteCode, ic.text)));
                            _showB();
                          }
                          if (inputOTP != OTP) {
                            _onBasicAlert(context);
                            _showB();
                          }
                          otp.clear();
                          ic.clear();
                          _hide();
                          _changef();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  _onBasicAlert(context) {
    Alert(
        context: context,
        title: "Error",
        desc: "Wrong Mail or Otp, Enter again",
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
