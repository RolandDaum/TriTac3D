import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

class WebRTCConnectionManager {
  /// - V A R s - ///

  // Firebase
  final FirebaseDatabase _rltdb = FirebaseDatabase.instance;
  List<StreamSubscription> _rltdbListener =
      []; // saves all the different _rltdb event listeners
  // Communication
  RTCPeerConnection? _peerConnection; // Main connection object
  RTCDataChannel? _dataChannel; // Communication Object
  // Stuff
  bool _isHost = false; // marker weither host or join
  Function(String data)? _onData;
  String? _gameCode; // GameCode which is the connection rltdb directory
  Function(RTCPeerConnectionState)? _onPeerConnectionState;
  Function(RTCDataChannelState)? _onDataChannelState;
  Function(String)? _onNewGameCode;
  VoidCallback? connectionEstablished;
  VoidCallback? connectionFailed;
  bool _onceConnected = false;
  bool _isConnected = false;

  /// - M E T H O D S - ///

  /// Creates a game offer in Firebase Realtime DB under the subdirectory games/{return STRING GAMECODE}
  Future<String> createGameOffer() async {
    await dispose();
    // Marks itself as the host (offerer)
    _isHost = true;

    // generates the game code cause he's the host (offerer)
    _gameCode = _genGameCode();

    // initialises the peerConnection
    await _createPeerConnection();

    // Creates offer, Set Offer as local Description, Write Offer to rltdb
    RTCSessionDescription offer = await _peerConnection!.createOffer({
      'mandatory': {
        'OfferToReceiveAudio': false,
        'OfferToReceiveVideo': false,
      },
      'optional': [],
    });
    await _peerConnection!.setLocalDescription(offer);
    await _rltdb.ref('games/$_gameCode/offer').set(offer
        .toMap()); // Needs to be await cause it creates the game code directory
    _rltdb
        .ref('games/$_gameCode')
        .update({'tsmp': DateTime.now().millisecondsSinceEpoch.toString()});

    // Listener for an answer
    _rltdbListener.add(await _rltdb
        .ref('games/$_gameCode/answer')
        .onValue
        .listen((event) async {
      if (event.snapshot.value != null &&
          _peerConnection!.signalingState !=
              RTCSignalingState.RTCSignalingStateStable) {
        // Sets the answer as remote Description
        Map<String, dynamic> data =
            (event.snapshot.value as Map).cast<String, dynamic>();
        await _peerConnection!.setRemoteDescription(RTCSessionDescription(
          data['sdp'],
          data['type'],
        ));
      }
    }));

    // Listener for all incoming ICE from the JOIN side
    _rltdbListener.add(await _rltdb
        .ref('games/$_gameCode/candidates/receiver')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        // Adds every new discoverd candidate
        Map<String, dynamic> data =
            (event.snapshot.value as Map).cast<String, dynamic>();
        _peerConnection?.addCandidate(RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ));
      }
    }));

    _onNewGameCode?.call(_gameCode!);
    return _gameCode!;
  }

  /// Joins a game offer from the Firebase Realtime DB under the subdirectory games/{STRING gameCode}
  Future<void> joinGame(String gameCode) async {
    if (_peerConnection?.connectionState != null &&
        (_peerConnection!.connectionState ==
                RTCPeerConnectionState.RTCPeerConnectionStateConnecting ||
            _peerConnection!.signalingState !=
                RTCSignalingState.RTCSignalingStateClosed)) {
      return;
    }
    await dispose();
    this._gameCode = gameCode;
    await _createPeerConnection();

    // Gets the corresponding remote Description from given gameCode directory
    DatabaseEvent dbEvent = await _rltdb.ref('games/$_gameCode/offer').once();
    if (dbEvent.snapshot.value != null) {
      // Sets the offer as remote Description
      Map<String, dynamic> offer =
          (dbEvent.snapshot.value as Map).cast<String, dynamic>();
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
    } else {
      // This is outside of the widget tree, so it can't display the browser popup I think
      (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android)
          ? Fluttertoast.showToast(
              msg: "$_gameCode not found", gravity: ToastGravity.BOTTOM)
          : null;
      await dispose();
      return;
    }

    // Generate Answer, Set Answer as local Description, Write Answer to rltdb
    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection?.setLocalDescription(answer);
    await _rltdb.ref('games/$_gameCode/answer/').set(answer.toMap());

    // Fetch all existing ICE's from HOST and adds them to PeerConnection
    await _rltdb
        .ref('games/$_gameCode/candidates/initiator')
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        // Adds all preexisting ICE to PeerConnection
        Map<String, dynamic> candidates =
            Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        candidates.forEach((key, value) {
          Map<String, dynamic> data = value.cast<String, dynamic>();
          _peerConnection?.addCandidate(RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          ));
        });
      }
    });

    // Fetches every new incoming ICE from Host and adds them to PeerConnection
    _rltdbListener.add(await _rltdb
        .ref('games/$_gameCode/candidates/initiator')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        // Adds new ICE to PeerConnection
        Map<String, dynamic> data =
            (event.snapshot.value as Map).cast<String, dynamic>();
        _peerConnection?.addCandidate(RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ));
      }
    }));
  }

  /// Initialises the _peerConnection object with given settings
  Future<void> _createPeerConnection() async {
    // Creates a peer Connecton Object with some iceServers for 'public' IPs
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            "stun:stun.l.google.com:19302",
            "stun:stun1.l.google.com:19302",
            "stun:stun2.l.google.com:19302",
            "stun:stun3.l.google.com:19302",
            "stun:stun4.l.google.com:19302",
            "stun:stun.stunprotocol.org:3478",
            "stun:stun.voipstunt.com:3478"
          ]
        }
      ],
      'sdpSemantics': 'uinified-plan'
    });

    // Dumps all own ice candidates into firebase
    _peerConnection!.onIceCandidate = (candidate) {
      _rltdb
          .ref('games/$_gameCode/candidates/' +
              (_isHost ? 'initiator' : 'receiver'))
          .push()
          .set(candidate.toMap());
    };

    // Just the event handler on different peer connection state events
    _peerConnection!.onConnectionState = (state) {
      _onPeerConnectionState?.call(state);
      // print(state.name);
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateNew:
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          // Fluttertoast.showToast(
          //     msg: "Connecting with opponend", gravity: ToastGravity.BOTTOM);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _onConnectionEstablished();
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _onConnectionFailure();
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          _onConnectionFailure();
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _peerConnection!
              .restartIce(); // if not restarting ICE it will only try like the first ICE or something and if it fails emdiatly dispose ...
          // _onConnectionFailure();
          break;
      }
    };

    _peerConnection!.onSignalingState = (state) {
      switch (state) {
        case RTCSignalingState.RTCSignalingStateClosed:
          break;
        case RTCSignalingState.RTCSignalingStateHaveLocalOffer:
          break;
        case RTCSignalingState.RTCSignalingStateHaveLocalPrAnswer:
          break;
        case RTCSignalingState.RTCSignalingStateHaveRemoteOffer:
          break;
        case RTCSignalingState.RTCSignalingStateHaveRemotePrAnswer:
          break;
        case RTCSignalingState.RTCSignalingStateStable:
          break;
      }
    };

    // Init all the different dataChannel events
    Function initDataChannelEvents = () {
      _dataChannel!.onMessage = (message) {
        _onData?.call(message.text);
      };
      _dataChannel!.onDataChannelState = (state) async {
        _onDataChannelState?.call(state);
        switch (state) {
          case RTCDataChannelState.RTCDataChannelConnecting:
            break;
          case RTCDataChannelState.RTCDataChannelOpen:
            connectionEstablished?.call();
            _onConnectionEstablished();
            break;
          case RTCDataChannelState.RTCDataChannelClosing:
            _onConnectionFailure();
            break;
          case RTCDataChannelState.RTCDataChannelClosed:
            _onConnectionFailure();
            break;
        }
      };
    };

    // Setting the dataChannel Object -> JOIN
    // Only triggered if he joins to a connection
    _peerConnection!.onDataChannel = (channel) {
      _dataChannel = channel;
      initDataChannelEvents();
    };

    // Creating the dataChannel Object -> HOST
    if (_isHost) {
      _dataChannel = await _peerConnection!
          .createDataChannel('dataChannel', RTCDataChannelInit());
      initDataChannelEvents();
    }
    return;
  }

  /// Generates a 4 digit game code
  String _genGameCode() {
    String code = "";
    for (int i = 0; i < 4; i++) {
      code += Random().nextInt(10).toString();
    }
    return code;
  }

  /// Sends the given data via the data channel
  Future<void> sendData(String data) async {
    // print(data);
    if (_dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      await _dataChannel?.send(RTCDataChannelMessage(data));
    }
    return;
  }

  /// Called everytime anything happends related to a successfull connection
  void _onConnectionEstablished() async {
    _isConnected = true;
    _onceConnected = true;
    if (_isHost) {
      await _rltdb.ref('games/$_gameCode').remove();
    }
  }

  /// Called everytime anything happends related to a connection failure
  void _onConnectionFailure() async {
    _isConnected = false;
    connectionFailed?.call();
    if (!_onceConnected) {
      await dispose();
      if (_isHost) {
        await createGameOffer();
      }
    }
  }

  /// GET AND SET METHODS ///

  void setOnData(Function(String) onData) {
    this._onData = onData;
  }

  void setOnPeerConnectionState(
      Function(RTCPeerConnectionState) onPeerConnectionState) {
    this._onPeerConnectionState = onPeerConnectionState;
  }

  void setOnDataChannelState(Function(RTCDataChannelState) onDataChannelState) {
    this._onDataChannelState = onDataChannelState;
  }

  void setOnNewGameCode(Function(String) onNewGameCode) {
    this._onNewGameCode = onNewGameCode;
  }

  bool isConnected() => this._isConnected;

  bool isHost() => this._isHost;

  /// REMOVES EVERYTHING ///
  Future<void> dispose() async {
    for (var listener in _rltdbListener) {
      await listener.cancel();
    }
    _rltdbListener.clear();

    await _dataChannel?.close();
    _dataChannel = null;

    await _peerConnection?.close();
    await _peerConnection?.dispose();
    _peerConnection = null;

    if (_isHost) {
      // Remove Entire game entry as the HOST
      await _rltdb.ref('games/$_gameCode').remove();
    } else {
      // Remove everything you wrote
      await _rltdb.ref('games/$_gameCode/answer').remove();
      await _rltdb.ref('games/$_gameCode/candidates/receiver').remove();
    }
  }
}
