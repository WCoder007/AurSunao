// @dart=2.9

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String userid;
  const HomePage({
    Key key,
    this.userid,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = 'Press the button and speak your heart out!';
  bool isListening = false;
  final Map<String, HighlightedWord> _highlights = {
    'sad': HighlightedWord(
      onTap: () => print('sad'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'happy': HighlightedWord(
      onTap: () => print('happy'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'angry': HighlightedWord(
      onTap: () => print('angry'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'hate': HighlightedWord(
      onTap: () => print('hate'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and speak your heart out!';
  double _confidence = 1.0;
  bool viewResults = false;

  String _happyText =
      "Hey you, seems like you are in a happy mood today, hope it continues throughout the day. Do spread your positive vibes to others and be all ears to someone who needs a good talk ,take care!";
  String _sadText =
      "Hello, it looks like you are sad today. Don't worry, I got you! \nHere are a few things you can do make your day brighter,Eat something sweet! \nNeed a good laugh? Laugh out on some jokes xD \nWatch F.R.I.E.N.D.S on Netflix and feel good!";
  String _angryText =
      "Hi, according to my analysis, you seem to be in an angry mood. Please calm down and think before you speak or do anything you will regret later. Here are a few things you can do to calm down. \nMeditate \nDo light workouts \nVisualize yourself calm";
  String _supText =
      "Hola, looks like you are surprised, hope its a good surprise :))";
  String _fearTExt =
      "Hey, you are not alone, I'll help you get over your fears.\nTry Meditation\nDo light exercsies\nListen to some songs";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void showResults() {
    setState(() {
      viewResults = true;
    });
  }

  void hideResults() {
    setState(() {
      viewResults = false;
    });
  }

  String finalMood = "";
  String moodResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.0),
                    Text(
                      "Aur Sunao!",
                      style: TextStyle(
                        fontFamily: "Chewy",
                        color: Colors.deepPurple[800],
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                  child: TextHighlight(
                    text: _text,
                    words: _highlights,
                    textStyle: const TextStyle(
                      fontSize: 21.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Text(
                'Accuracy: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.deepPurple)),
                    onPressed: () async {
                      setState(() => _isListening = false);
                      _speech.stop();
                      String uri =
                          "https://aursunao.herokuapp.com/emotion_detector?text=" +
                              _text;

                      final response = await http.get(Uri.parse(uri));
                      final decoded =
                          json.decode(response.body) as Map<String, dynamic>;
                      print(decoded);
                      String mood = "";
                      decoded.keys.forEach((element) {
                        if (decoded[element] > 0.5) {
                          mood = element;
                        }
                      });
                      if (mood == "") {
                        mood = "Neutral";
                      }

                      String savingdata =
                          "https://aursunaobackend.herokuapp.com/save?user=" +
                              widget.userid +
                              "&text=" +
                              _text;
                      print(savingdata);
                      await http.get(Uri.parse(savingdata));

                      setState(() {
                        moodResult = mood;
                        if (mood == "Happy") {
                          moodResult = _happyText;
                        } else if (mood == "Sad") {
                          moodResult = _sadText;
                        } else if (mood == "Fear") {
                          moodResult = _fearTExt;
                        } else if (mood == "Suprise") {
                          moodResult = _supText;
                        } else if (mood == "angry") {
                          moodResult = _angryText;
                        } else {
                          moodResult = "Hope it's all good!";
                        }
                        finalMood = mood;
                        showResults();
                      });
                    },
                    padding: EdgeInsets.all(10.0),
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    child: Text("Save to Log"),
                  ),
                ),
              ),
              viewResults
                  ? SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Container(
                        color: Colors.purple[100],
                        margin: EdgeInsets.fromLTRB(25, 0, 25, 25),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      finalMood,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      moodResult,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }

  void _listen() async {
    setState(() {
      hideResults();
    });
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
