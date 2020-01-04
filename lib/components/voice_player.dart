import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum PlayerState { stopped, playing, paused }

class MyPlayer {

  String url;
  bool isLocal;
  PlayerMode mode;
  
  MyPlayer(){
    _setupPlayer();
    _initAudioPlayer();
  }

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';


  void _setupPlayer()async{
     final dir =await getApplicationDocumentsDirectory();
     final file = File('${dir.path}/audio.mp3');
    
     url=file.path;
     isLocal=true;
     mode=PlayerMode.MEDIA_PLAYER;
  }

  void _initAudioPlayer() {
     _audioPlayer = AudioPlayer(mode: mode);
     _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
     _duration = duration;
    });

     _positionSubscription =
     _audioPlayer.onAudioPositionChanged.listen((p) => _position = p);   
     _playerCompleteSubscription =_audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      _position = _duration;

    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');

        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
        _audioPlayerState = state;
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      _audioPlayerState = state;
    });
  }


 Future<int> play() async {

    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
        await _audioPlayer.play(url, isLocal: isLocal, position: playPosition);
    if (result == 1) _playerState = PlayerState.playing;
    return result;
  }


  Future<int> pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) _playerState = PlayerState.paused;
    return result;
  }

  Future<int> stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
        _playerState = PlayerState.stopped;
        _position = Duration();
    }
    return result;
  }

  void _onComplete() {
   _playerState = PlayerState.stopped;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}