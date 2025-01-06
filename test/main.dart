import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tritac3d/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebRTC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebRTCApp(),
    );
  }
}

class WebRTCApp extends StatefulWidget {
  const WebRTCApp({Key? key}) : super(key: key);

  @override
  _WebRTCAppState createState() => _WebRTCAppState();
}

class _WebRTCAppState extends State<WebRTCApp> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  bool _isOfferer = false;
  List<StreamSubscription> _subscriptions = []; // Liste für StreamSubscriptions

  Future<void> _setupPeerConnection() async {
    final configuration = {
      'iceServers': [
        {
          'urls': [
            "stun:stun.l.google.com:19302",
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
            "stun:stun3.l.google.com:19302",
            "stun:stun4.l.google.com:19302",
            'stun:stun.stunprotocol.org:3478',
            'stun:stun.voipstunt.com:3478'
          ]
        }
      ]
    };
    _peerConnection = await createPeerConnection(configuration);

    _peerConnection?.onConnectionState = (state) async {
      print(state.toString());
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          print("");
          print("CONNECTED");
          print("");
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _reset();
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _reset();
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          _reset();
          break;

        default:
      }
    };

    _peerConnection?.onIceCandidate = (candidate) {
      _database
          .ref('signaling/0000/candidates/' +
              (_isOfferer ? 'offerer' : 'answerer'))
          .push()
          .set(candidate.toMap());
    };

    _peerConnection?.onDataChannel = (channel) {
      setState(() {
        _dataChannel = channel;
      });
      _setupDataChannelEvents(channel);
    };
    print("");
    print(_isOfferer);
    print("");

    if (_isOfferer) {
      final dataChannelInit = RTCDataChannelInit();
      _dataChannel = await _peerConnection?.createDataChannel(
          'dataChannel', dataChannelInit);
      _setupDataChannelEvents(_dataChannel);
    }
  }

  void _setupDataChannelEvents(RTCDataChannel? channel) {
    channel?.onMessage = (message) {
      print('Message received: ${message.text}');
    };
    channel?.onDataChannelState = (state) async {
      switch (state) {
        case RTCDataChannelState.RTCDataChannelOpen:
          await _dataChannel?.send(RTCDataChannelMessage(
              "HELLO WORLD from datachannel event listener"));
          break;
        default:
      }
    };
  }

  Future<void> _createOffer() async {
    setState(() {
      _isOfferer = true;
    });
    await _setupPeerConnection();
    final offer = await _peerConnection?.createOffer({
      'mandatory': {
        'OfferToReceiveAudio': false,
        'OfferToReceiveVideo': false,
      },
      'optional': [],
    });
    await _peerConnection?.setLocalDescription(offer!);
    _database.ref('signaling/0000/offer').set(offer?.toMap());

    await _database.ref('signaling/0000/answer').onValue.listen((event) async {
      if (event.snapshot.value != null) {
        Map<String, dynamic> data =
            (event.snapshot.value as Map).cast<String, dynamic>();
        await _peerConnection?.setRemoteDescription(RTCSessionDescription(
          data['sdp'],
          data['type'],
        ));
      }
    });
    // Event-Listener für neu hinzugefügte ICE-Candidates
    final subscription = await _database
        .ref('signaling/0000/candidates/answerer')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        print("CAD FOUND FROM ANSWERER");
        Map<String, dynamic> data =
            (event.snapshot.value as Map).cast<String, dynamic>();
        _peerConnection?.addCandidate(RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ));
      }
    });
    _subscriptions.add(subscription);
  }

  Future<void> _joinOffer() async {
    await _setupPeerConnection();

    await _database.ref('signaling/0000/offer').once().then((event) async {
      if (event.snapshot.value != null) {
        ;
        Map<String, dynamic> offer =
            (event.snapshot.value as Map).cast<String, dynamic>();

        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );
        final answer = await _peerConnection?.createAnswer();
        await _peerConnection?.setLocalDescription(answer!);
        await _database.ref('signaling/0000/answer').set(answer!.toMap());
      } else {
        print("PeerConnection is not in a stable state!");
      }
    });

    final ref = _database.ref('signaling/0000/candidates/offerer');
    // Alle vorhandenen ICE-Candidates hinzufügen
    await ref.once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<String, dynamic> candidates =
            Map<String, dynamic>.from(snapshot.snapshot.value as Map);

        candidates.forEach((key, value) {
          print("CAND FROM ANSWERER - PRE EXISTING CAND:");
          Map<String, dynamic> data = value.cast<String, dynamic>();
          _peerConnection?.addCandidate(RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          ));
        });
      }
    });

// Event-Listener für neu hinzugefügte ICE-Candidates
    final subscription = await ref.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        print("CAND FROM ANSWERER - NEW CAND:");
        Map<String, dynamic> data =
            (event.snapshot.value as Map).cast<String, dynamic>();
        _peerConnection?.addCandidate(RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ));
      }
    });
    _subscriptions.add(subscription);
  }

  void _reset() async {
    print("");
    print("\n RESETTING \n");
    print("");
    for (var subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear(); // Liste leeren
    await _dataChannel?.close();

    await _peerConnection?.close();
    await _peerConnection?.dispose();
    setState(() {
      _isOfferer = false;
    });
    await _database.ref('signaling/0000/').remove();
    _dataChannel = null;
    _peerConnection = null;

    // await _setupPeerConnection();
    print("");
    print("\n FINISHED RESETTING \n");
    print("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebRTC with Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createOffer,
              child: const Text('Create Offer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _joinOffer,
              child: const Text('Join Connection'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _reset();
              },
              child: const Text('RESET'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _dataChannel?.send(RTCDataChannelMessage("HELLO WORLD"));
              },
              child: const Text('send message'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    _peerConnection?.close();
    _peerConnection?.dispose();
    _dataChannel?.close();
    super.dispose();
  }
}
