import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/modal/modal_event.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


import '../../../base/color_data.dart';
import '../../dialog/event_publish_dialog.dart';
import 'barcode_detail_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  Event? eventModel;
   BarcodeScannerScreen({super.key,this.eventModel});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String? _barcode;
  late bool visible;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
   bool _showSnackbar = true;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        setState(() {
          _showSnackbar = false;
        });
        timer.cancel();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(
         'Scard QR Code',
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 17.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // if (result != null)
                  //   Text(
                  //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  // else
                  //   const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)),color: accentColor),
                        margin: const EdgeInsets.all(8),
                        child: InkWell(
                            onTap: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0,bottom: 10.0),
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      Icon(Icons.flashlight_on,color: Colors.white,),
                                      Text("Camera",style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10.0),),
                                    ],
                                  );
                                  // return Text('Flash: ${snapshot.data}',style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600),);
                                },
                              ),
                            )),
                      ),
                      Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30.0)),color: accentColor),
                        margin: const EdgeInsets.all(8),
                        child: InkWell(
                            onTap: () async {
                              await controller?.flipCamera();
                              setState(() {}); 
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0,bottom: 10.0),
                              child: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Column(
                                      children: [
                                        Icon(Icons.cameraswitch_rounded,color: Colors.white,),
                                     
                                      Text("Flip",style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10.0),),
                                      ],
                                    );
                                    // Text(
                                    //     'Camera Facing ${describeEnum(snapshot.data!)}',style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600),);
                                  } else {
                                    return const Text('loading');
                                  }
                                },
                              ),
                            )),
                      ),

                        Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)),color: accentColor),
                        margin: const EdgeInsets.all(8),
                        child: InkWell(
                            onTap: () async {
                            await controller?.pauseCamera();
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0,bottom: 10.0),
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      Icon(Icons.pause,color: Colors.white,),
                                      
                                      Text("Pause",style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10.0),),
                                    ],
                                  );
                                  // return Text('Flash: ${snapshot.data}',style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600),);
                                },
                              ),
                            )),
                      ),
    Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)),color: accentColor),
                        margin: const EdgeInsets.all(8),
                        child: InkWell(
                            onTap: () async {
                            await controller?.resumeCamera();
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0,bottom: 10.0),
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      Icon(Icons.play_arrow_rounded,color: Colors.white,),
                                    
                                      Text("Play",style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10.0),),
                                    ],
                                  );
                                  // return Text('Flash: ${snapshot.data}',style: TextStyle(fontFamily: "Sofia",color: Colors.white,fontWeight: FontWeight.w600),);
                                },
                              ),
                            )),
                      ),


                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.pauseCamera();
                  //         },
                  //         child: const Text('pause',
                  //             style: TextStyle(fontSize: 20)),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.resumeCamera();
                  //         },
                  //         child: const Text('resume',
                  //             style: TextStyle(fontSize: 20)),
                  //       ),
                  //     )
                  //   ],
                  // ),
              
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (scanData.code == widget.eventModel!.title){
           controller?.pauseCamera();
           FirebaseFirestore.instance
                  .collection('event')
                  .doc(widget.eventModel!.id)
                  .update({'joined': FieldValue.increment(1)});
            Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) =>  BarcodeDetailScreen(data: '${result!.code}',event:widget.eventModel )));
        }else{
           controller?.pauseCamera();
          // ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         duration: const Duration(seconds: 2),
          //         showCloseIcon: true,
          //         backgroundColor: Colors.redAccent,
          //         content: Text(
          //           'QR Code is not valid',
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     );
           showDialog(
                        builder: (context) {
                          return const ErrorDialog();
                        },
                        context: context);
       
        }
      

        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
