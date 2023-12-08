import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'package:http/http.dart' as http;

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with TickerProviderStateMixin {
  bool _recording = false;
  late Stream<Map<dynamic, dynamic>> result;
  String _sound = "";

  late TabController _tabController;
  bool _isAudioPlaying = false;

  String sound1 = 'assets/sound1.mp3';

  //int audioToPlay = 4;

  String liveAudio = 'assets/live.mp3';

  final String buzzerUrl = 'http://192.168.4.1/Buzzer';
  bool _isBuzzerOn = false;
  String buzzerSate = 'OFF';

  Future turnBuzzerOn() async {
    var response = await http.get(Uri.parse('http://127.168.4.1/'));
    if (response.statusCode == 200) {
      print('Buzzer activated!');
    } else {
      print('Error activating buzzer. Status code: ${response.statusCode}');
    }
  }

  Future turnBuzzerOff() async {
    var response = await http.get(Uri.parse('http://127.168.4.1/'));
    if (response.statusCode == 200) {
      print('Buzzer deactivated!');
    } else {
      print('Error deactivating buzzer. Status code: ${response.statusCode}');
    }
  }

  Future<void> _toggleBuzzer(bool isOn) async {
    if (isOn) {
      await turnBuzzerOn();
    } else {
      await turnBuzzerOff();
    }
    setState(() {
      _isBuzzerOn = isOn;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    try {
      TfliteAudio.loadModel(
          model: 'assets/soundclassifier.tflite',
          label: 'assets/labels.txt',
          inputType: 'rawAudio',
          numThreads: 1,
          isAsset: true);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: TabBarView(
        controller: _tabController,
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  bottom: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg.jpeg'),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 800,
                  margin: EdgeInsets.only(
                    top: 60,
                    left: 15,
                    right: 10,
                    //bottom: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        topRight: Radius.circular(70)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 60,
                            ),
                            height: 45,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green,
                            ),
                            child: TabBar(
                                padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 2,
                                  bottom: 2,
                                ),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                                indicatorColor: Colors.red,
                                indicatorWeight: 3.0,
                                labelColor: Colors.white,
                                controller: _tabController,
                                tabs: [
                                  Text(
                                    '🔔 Notifications',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '🎙️    Parler',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          width: 50,
                          margin: EdgeInsets.only(
                              top: 50, left: 20, right: 20, bottom: 150),
                          height: 120,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 121, 246, 127),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: 100),
                          child: Column(
                            children: [
                              Visibility(
                                visible: _recording || _isAudioPlaying
                                    ? false
                                    : true,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 60),
                                      child: GestureDetector(
                                        onTap: () {
                                          playSound('assets/4.mp3');
                                        },
                                        child: Icon(
                                          Icons.play_circle_outline_rounded,
                                          color: Colors.black.withOpacity(0.6),
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),

                              //sound 5
                              Visibility(
                                visible: _recording || _isAudioPlaying
                                    ? false
                                    : true,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 60),
                                      child: GestureDetector(
                                        onTap: () {
                                          playSound('assets/5.mp3');
                                        },
                                        child: Icon(
                                          Icons.play_circle_outline_rounded,
                                          color: Colors.black.withOpacity(0.6),
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              //sound 3
                              Visibility(
                                visible: _recording || _isAudioPlaying
                                    ? false
                                    : true,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 60),
                                      child: GestureDetector(
                                        onTap: () {
                                          playSound('assets/3.mp3');
                                        },
                                        child: Icon(
                                          Icons.play_circle_outline_rounded,
                                          color: Colors.black.withOpacity(0.6),
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /* Visibility(
                                visible: _isAudioPlaying ? false : true,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 20, top: 60),
                                    child: Switch(
                                      value: _isBuzzerOn,
                                      onChanged: (bool value) {
                                        _toggleBuzzer(value);
                                      },
                                    ),
                                  ),
                                ),
                              ) */
                            ],
                          ),
                        ),
                        // sound 4

                        Visibility(
                          visible: (_isAudioPlaying) ? true : false,
                          child: Lottie.asset(
                            alignment: Alignment.bottomCenter,
                            'assets/sound-voice-waves.json',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //2em tab

          SafeArea(
            child: Container(
              height: 800,
              margin: EdgeInsets.only(
                top: 60,
                left: 15,
                right: 10,
                //bottom: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 40, right: 40, bottom: 420),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 60,
                        ),
                        height: 45,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green,
                        ),
                        child: TabBar(
                            padding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 2,
                              bottom: 2,
                            ),
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                            ),
                            indicatorColor: Colors.red,
                            indicatorWeight: 3.0,
                            labelColor: Colors.white,
                            controller: _tabController,
                            tabs: [
                              Text(
                                '🔔 Alertes',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '🎙️    Parler',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ),
                    Visibility(
                      visible: (_isAudioPlaying) ? true : false,
                      child: Lottie.asset(
                        alignment: Alignment.bottomCenter,
                        'assets/sound-voice-waves.json',
                      ),
                    ),
                    /* _recording ? Lottie.asset(
                          alignment: Alignment.bottomCenter,
                          'assets/recording.json',
                        ):  Lottie.asset(
                          alignment: Alignment.bottomCenter,
                          'assets/recording.json',
                        ), */
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Visibility(
                        visible: _isAudioPlaying ? false : true,
                        child: GestureDetector(
                          onTap: () {
                            /* _recorder(); */
                            setState(() {
                              _recording = true;
                            });

                            Future.delayed(Duration(seconds: 3), () {
                              setState(() {
                                _recording = false;
                                playSound('assets/5.mp3');
                              });
                            });
                          },
                          child: _recording
                              ? Lottie.asset('assets/recording.json',
                                  height: 250)
                              : Padding(
                                  padding: EdgeInsets.only(top: 150),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          )
                                        ]),
                                    child: Icon(
                                      Icons.mic,
                                      size: 40,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _recorder() {
    print('recording...');
    String recognition = "";
    if (!_recording) {
      setState(() => _recording = true);
      result = TfliteAudio.startAudioRecognition(
        numOfInferences: 1,
        audioLength: 0,
        sampleRate: /* 44100 */ 16000,
        //audioLength: 44032,
        bufferSize: 22016,
        detectionThreshold: 0.3,
      );
      result.listen((event) {
        recognition = event["recognitionResult"];
      }).onDone(() {
        setState(() {
          _recording = false;
          _sound = recognition.split(" ")[1];
        });
      });
    }
  }

  void _stop() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }

  void playSound(audioPath) async {
    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

    audioPlayer
        .open(
          Audio(audioPath),
          autoStart: true,
          showNotification: true,
        )
        .then((value) => setState(() {
              _isAudioPlaying = true;
            }));

    audioPlayer.playlistAudioFinished.listen((data) {
      setState(() {
        _isAudioPlaying = false;
      });
    });
  }
}
