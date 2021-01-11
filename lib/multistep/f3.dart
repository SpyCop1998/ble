import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// import 'f4.dart';
class f4 extends StatefulWidget {
  String inviteCode;
  String mail, contactN, userName;
  String location;

  f4(String i, String un, String cn, String m, String l) {
    inviteCode = i;
    userName = un;
    contactN = cn;
    mail = m;
    location = l;
  }

  @override
  _f4State createState() => _f4State();
}

class _f4State extends State<f4> {
  bool _isHidden1 = true;
  bool _isHidden2 = true;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController p1 = TextEditingController();
  final TextEditingController p2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("finish"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  obscureText: _isHidden1,
                  validator: (value) {
                    if (value == null) {
                      return "Enter some value";
                    }
                    return null;
                  },
                  controller: p1,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffix: InkWell(
                      onTap: _togglePasswordView1,
                      child: Icon(
                        _isHidden1 ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  obscureText: _isHidden2,
                  validator: (value) {
                    if (value == null) {
                      return "Enter some value";
                    }
                    return null;
                  },
                  controller: p2,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffix: InkWell(
                      onTap: _togglePasswordView2,
                      child: Icon(
                        _isHidden2 ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  child: Text("Finish"),
                  onPressed: () {
                    String pass1 = p1.text;
                    String pass2 = p2.text;
                    if (pass1.isNotEmpty &&
                        pass2 == pass1 &&
                        pass2.length > 6) {
                    } else {
                      _onBasicAlert(context);
                    }
                    p1.clear();
                    p2.clear();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onBasicAlert(context) {
    Alert(
        context: context,
        title: "Error",
        desc: "Password should be of 6 digits, Enter again",
        buttons: [
          DialogButton(
            child: Text("Enter again"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]).show();
  }

  void _togglePasswordView1() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }
}
