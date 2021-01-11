import 'package:ble/multistep/f3.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'f2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoder/geocoder.dart';
import 'package:android_intent/android_intent.dart';

class f2 extends StatefulWidget {
  String inviteCode;

  f2(String i, String mail) {
    inviteCode = i;
    mail = mail;
  }

  @override
  _f2State createState() => _f2State();
}

class _f2State extends State<f2> {

  bool loader=true;
  void _loaderHide()
  {
    setState(() {
      loader=false;
    });
  }

  final TextEditingController locate = TextEditingController();
  bool _loc = true;

  void _chnageloc() {
    setState(() {
      _loc = false;
    });
  }

  bool _lo = false;

  void _lshow() {
    setState(() {
      _lo = true;
    });
  }

  bool locf = true;

  void _hideLF() {
    setState(() {
      locf = false;
    });
  }

  final _formkey = GlobalKey<FormState>();

  String mail;

  final TextEditingController un = TextEditingController();

  final TextEditingController cn = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step3"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: un,
                  validator: (value) {
                    if (value == null) {
                      return "Enter some value";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "User Name"),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: cn,
                  validator: (value) {
                    if (value == null) {
                      return "Enter Some Value";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Contact No.",
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: locf,
                  child: TextFormField(
                    controller: locate,
                    enabled: _loc,
                    decoration: InputDecoration(hintText: "Location"),
                    onTap: () async {
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: loader,
                        child: CircularProgressIndicator(),
                      );
                      Position l = await locateUser();
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              l.latitude, l.longitude);

                      // Toast.show("${placemarks.first.locality}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      locate.text =
                          "${placemarks.first.locality}, ${placemarks.first.subLocality}, ${placemarks.first.postalCode}";
                      _loaderHide();
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
                    visible: _lo,
                    child: DropDownSpinner()),
                SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  child: Text("Next"),
                  onPressed: () {
                    String userName = un.text;
                    String contact = cn.text;
                    if (userName.isNotEmpty &&
                        contact.isNotEmpty &&
                        contact.length == 10) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => f4(widget.inviteCode,
                                  userName, contact, mail, _dropdownValue)));
                    } else {
                      _onBasicAlert(context);
                    }
                    un.clear();
                    cn.clear();
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
    Alert(context: context, title: "Error", desc: " Enter again", buttons: [
      DialogButton(
        child: Text("Enter again"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ]).show();
  }

  Future<Position> locateUser() async {
    LocationPermission permission;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _lshow();
      _hideLF();
      // _openLocationSetting();
      return Future.error("Location disables");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _lshow();
      // _chnageloc();

      // _hideLF();
      return Future.error("Denied");
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _lshow();
        // _chnageloc();
        _hideLF();
        return Future.error("Denied");
      }
    }
    _chnageloc();
    return await Geolocator.getCurrentPosition();
  }


  void _openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

}

class DropDownSpinner extends StatefulWidget {
  @override
  _DropDownSpinnerState createState() => _DropDownSpinnerState();
}

String _dropdownValue = 'Delhi';

class _DropDownSpinnerState extends State<DropDownSpinner> {
  List<String> spinnerItems = ['Delhi', 'Mumbai', 'Punjab', 'Goa', 'Lucknow'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            isExpanded: true,
            value: _dropdownValue,
            icon: Icon(Icons.home),
            onChanged: (String data) {
              setState(() {
                _dropdownValue = data;
              });
            },
            items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
