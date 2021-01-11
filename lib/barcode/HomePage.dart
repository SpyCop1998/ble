import 'dart:io';
import 'package:ble/multistep/f1.dart';
import 'package:ble/multistep/f2.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'FormPage.dart';
import 'package:get/get.dart';
const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
BuildContext _context;
class HomePage extends StatefulWidget {
  const HomePage({Key key,}):super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Barcode result;
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 4,child: _buildQrView(context),),
          Expanded(flex: 1,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // result!=null?
                // Text("Barcode text : ${result.code}")
                //   // Text('Barcode text : ${describeEnum(result.toString())}')
                // :
                //   Text('Scan a code')
                // ,


                Row(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.all(8),
                    //   child: RaisedButton(
                    //     onPressed: (){
                    //       if(controller!=null){
                    //         controller.toggleFlash();
                    //       }
                    //       if(_isFlashOn(flashState)){
                    //         setState(() {
                    //           flashState=flashOff;
                    //         });
                    //
                    //       }
                    //       else{
                    //         setState(() {
                    //           flashState=flashOn;
                    //         });
                    //       }
                    //     },
                    //     child: Text(flashState,style: TextStyle(fontSize: 20),),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.all(8),
                    //   child: RaisedButton(
                    //     onPressed: (){
                    //       if(controller!=null){
                    //         controller.flipCamera();
                    //         if(_isBackCamera(cameraState)){
                    //           setState(() {
                    //             cameraState= frontCamera;
                    //           });
                    //         }
                    //         else{
                    //           setState(() {
                    //             cameraState=backCamera;
                    //           });
                    //         }
                    //       }
                    //     },
                    //     child: Text(cameraState,style: TextStyle(fontSize:20 ),),
                    //   ),
                    // )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>f1()));
                          controller.resumeCamera();
                          // controller?.pauseCamera();
                        },
                        child: Text('Manual Submit',style: TextStyle(fontSize: 20),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: RaisedButton(
                        onPressed: (){
                          String c=result.code;
                          if(c.length==15){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>f3(result.code)));
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>FormPage(result.code)));
                            // controller?.resumeCamera();
                            controller.resumeCamera();
                          }else
                            {
                              Toast.show("Scan result null", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                            }
                        },
                        child: Text('Go With this Code',style: TextStyle(fontSize: 20),),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),)
        ],
      ),
    );
  }
  bool _isFlashOn(String current){
    return flashOn==current;
  }
  bool _isBackCamera(String current){
    return backCamera==current;
  }

  Widget _buildQrView(BuildContext context){

    var scanArea=(MediaQuery.of(context).size.width<400 ||
    MediaQuery.of(context).size.height<400)?300.0:450.0;

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification){
      Future.microtask(() => controller?.updateDimensions(qrKey,scanArea: scanArea));
      return false;
      },
      child: SizeChangedLayoutNotifier(
        key:const Key('qr-size-notifier'),
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea
          ),
        ),
      ),
    );

  }

  _onBasicAlert(context){
    Alert(
      context: context,
      title: "Error",
      desc: "Wrong Barcode, scan again",
      buttons: [
        DialogButton(
          child: Text("Scan again"),
          onPressed: (){
            controller.resumeCamera();
            Navigator.pop(context);
          },
        ),
      ]
    ).show();
  }

  void _onQRViewCreated(QRViewController controller){
    this.controller=controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.pauseCamera();
        // controller.resumeCamera();
        if(result!=null) {
          if(result.code.length!=15)
          {
            Get.dialog(_onBasicAlert(context));
            controller.resumeCamera();
          }
        }
      });

    }

    );

  }
  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

}
