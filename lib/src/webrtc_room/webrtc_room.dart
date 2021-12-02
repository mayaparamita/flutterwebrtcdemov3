import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'webrtc_signaling.dart';
import '../pages/displayDataPage.dart';

Future<void> WebrtcRoom1() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WebrtcRoom2());
}

class WebrtcRoom2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebrtcRoom(),
    );
  }
}

class WebrtcRoom extends StatefulWidget {
  WebrtcRoom({Key key}) : super(key: key);

  @override
  _WebrtcRoomState createState() => _WebrtcRoomState();
}

class _WebrtcRoomState extends State<WebrtcRoom> {
  WebrtcSignaling signaling = WebrtcSignaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    // auto open camera & mic
    signaling.openUserMedia(_localRenderer, _remoteRenderer).whenComplete(() {
      // auto create room
      signaling.createRoom(_remoteRenderer).then((data) {
        roomId=data;
        textEditingController.text = roomId;
      });
    } );
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Call with Agent"),
      ),
      body: Column(
        children: [
          //SizedBox(height: 8),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         signaling.openUserMedia(_localRenderer, _remoteRenderer);
          //       },
          //       child: Text("Open camera & microphone"),
          //     ),
          //     SizedBox(
          //       width: 8,
          //     ),
          //     ElevatedButton(
          //       onPressed: () async {
          //         roomId = await signaling.createRoom(_remoteRenderer);
          //         textEditingController.text = roomId;
          //         setState(() {});
          //       },
          //       child: Text("Create room"),
          //     ),
          //     SizedBox(
          //       width: 8,
          //     ),
          //
          //   ],
          // ),
          //START
          // Expanded(
          //   child:
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Expanded(
          //             child:
          //         RTCVideoView(_localRenderer, mirror: true)
          //         ),
          //         Expanded(child: RTCVideoView(_remoteRenderer)),
          //       ],
          //     ),
          //
          //   ),
          // ),
          // END
          SizedBox(height: 178),
          Expanded(
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child:RTCVideoView(_localRenderer, mirror: true),
                  ),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Client Video                             "),
                    Text("Agent Video")]
              ),
            ],
          ),
          //END
          // Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text("Agent Video                               "),
          //       Text("Client Video")
          //     ]),


          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
          //             Text("Client Video")
          //           ]
          //         ),
          //         Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children:[
          //               Expanded(child: RTCVideoView(_remoteRenderer)),
          //               Text("Agent Video")
          //             ]
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 148),
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     // Add roomId
              //     signaling.joinRoom(
              //       textEditingController.text,
              //       _remoteRenderer,
              //     );
              //   },
              //   child: Text("Join room"),
              // ),
              // SizedBox(
              //   width: 8,
              // ),
              // START: Comment button hangup
              // ElevatedButton(
              //   onPressed: () {
              //     signaling.hangUp(_localRenderer);
              //     Navigator.push(
              //         context, MaterialPageRoute(builder: (context) => DisplayDataPage()));
              //   },
              //   //child: Text("Hangup"),
              //   child: Icon(Icons.call_end_rounded),
              //   style: ButtonStyle(
              //     shape: MaterialStateProperty.all(CircleBorder()),
              //     padding: MaterialStateProperty.all(EdgeInsets.all(20)),
              //     backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
              //     overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              //       if (states.contains(MaterialState.pressed)) return Colors.red; // <-- Splash color
              //     }),
              //   ),
              // )
              // END: Comment button hangup
            ],
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text("Join the following Room: "),
          //       Flexible(
          //         child: TextFormField(
          //           controller: textEditingController,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}
