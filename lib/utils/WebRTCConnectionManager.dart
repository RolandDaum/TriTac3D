import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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

  /// - M E T H O D S - ///

  /// Creates a game offer in Firebase Realtime DB under the subdirectory games/{return STRING GAMECODE}
  Future<String> createGame() async {
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
    _rltdb.ref('games/$_gameCode/offer').set(offer.toMap());

    // Listener for an answer
    _rltdbListener.add(await _rltdb
        .ref('games/$_gameCode/answer')
        .onValue
        .listen((event) async {
      if (event.snapshot.value != null) {
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
    await dispose();
    this._gameCode = gameCode;
    await _createPeerConnection();

    // Gets the corresponding remote Description from given gameCode directory
    await _rltdb.ref('games/$_gameCode/offer').once().then((event) async {
      if (event.snapshot.value != null) {
        // Sets the offer as remote Description
        Map<String, dynamic> offer =
            (event.snapshot.value as Map).cast<String, dynamic>();
        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );
      }
    });

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
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
            "stun:stun3.l.google.com:19302",
            "stun:stun4.l.google.com:19302",
            'stun:stun.stunprotocol.org:3478',
            'stun:stun.voipstunt.com:3478'
          ]
        }
      ]
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
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateNew:
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
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
          _onConnectionFailure();
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
    if (_dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      await _dataChannel?.send(RTCDataChannelMessage(data));
    }
    return;
  }

  /// Called everytime anything happends related to a successfull connection
  void _onConnectionEstablished() async {
    if (_isHost) {
      await _rltdb.ref('games/$_gameCode').remove();
    }
  }

  /// Called everytime anything happends related to a connection failure
  void _onConnectionFailure() async {
    connectionFailed?.call();
    await dispose();
    if (_isHost) {
      await createGame();
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

  /// REMOVES EVERYTHING ///
  Future<void> dispose() async {
    // connectionFailed?.call(); // IDK if I should call it on dispose, cause it is some kind of connection failure

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
