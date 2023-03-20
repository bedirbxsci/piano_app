

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Piano(),
    );
  }
}

enum KeyColor { WHITE, BLACK }

class PianoKey extends StatelessWidget {
  final KeyColor color;
  final double width;
  final int midiNote;
  final FlutterMidi flutterMidi;

  const PianoKey.white({
    required this.width,
    required this.midiNote,
    required this.flutterMidi,
  }) : this.color = KeyColor.WHITE;

  const PianoKey.black({
    required this.width,
    required this.midiNote,
    required this.flutterMidi,
  }) : this.color = KeyColor.BLACK;

  playNote() {
    flutterMidi.playMidiNote(midi: midiNote);
  }

  /// Send a NOTE OFF message
  stopNote() {
    flutterMidi.stopMidiNote(midi: midiNote);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => playNote(),
      onTapUp: (_) => stopNote(),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color == KeyColor.WHITE ? Colors.white : Colors.black,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
      ),
    );
  }
}


class Piano extends StatefulWidget {
  
  const Piano({Key? key}) : super(key: key);

  @override
  _PianoState createState() => _PianoState();
}

class _PianoState extends State<Piano> {
  final FlutterMidi flutterMidi = FlutterMidi();

  @override
  void initState() {
    setupMIDIPlugin();
    super.initState();
  }

  Future<void> setupMIDIPlugin() async {
    flutterMidi.unmute();
    ByteData _byte = await rootBundle.load("PATH_TO_YOUR_SF2_FILE");
    flutterMidi.prepare(sf2: _byte);
  }
  final octaveNumber = 3;

  get octaveStartingNote => (octaveNumber * 12) % 128;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final whiteKeySize = constraints.maxWidth / 7;
        final blackKeySize = whiteKeySize / 2;
        return Stack(
          children: [
            _buildWhiteKeys(whiteKeySize),
            _buildBlackKeys(constraints.maxHeight, blackKeySize, whiteKeySize),
          ],
        );
      },
    );
  }
  _buildWhiteKeys(double whiteKeySize) {
  return Row(
    children: [
      PianoKey.white(
        width: whiteKeySize,
        midiNote: octaveStartingNote,
        flutterMidi: flutterMidi
        
        ,
      ),
      PianoKey.white(
        width: whiteKeySize,
        midiNote: octaveStartingNote + 2,
                flutterMidi: flutterMidi
      ),
      PianoKey.white(
        width: whiteKeySize,
        midiNote: octaveStartingNote + 4,
                flutterMidi: flutterMidi
      ),
      PianoKey.white(
        width: whiteKeySize,
        midiNote: octaveStartingNote + 5,
                flutterMidi: flutterMidi
      ),
      PianoKey.white(
        width: whiteKeySize,
        midiNote: octaveStartingNote + 7,
                flutterMidi: flutterMidi
      ),
      PianoKey.white(
        width: whiteKeySize,
        midiNote: octaveStartingNote + 9,
                flutterMidi: flutterMidi
      ),
      PianoKey.white(
        width: whiteKeySize,
        midiNote: octaveStartingNote + 11,
                flutterMidi: flutterMidi
      )
    ],
  );
}

_buildBlackKeys(double pianoHeight, double blackKeySize, double whiteKeySize) {
  return Container(
    height: pianoHeight * 0.55,
    child: Row(
      children: [
        SizedBox(
          width: whiteKeySize - blackKeySize / 2,
        ),
        PianoKey.black(
          width: blackKeySize,
          midiNote: octaveStartingNote + 1,
                  flutterMidi: flutterMidi
        ),
        SizedBox(
          width: whiteKeySize - blackKeySize,
        ),
        PianoKey.black(
          width: blackKeySize,
          midiNote: octaveStartingNote + 3,
                  flutterMidi: flutterMidi
        ),
        SizedBox(
          width: whiteKeySize,
        ),
        SizedBox(
          width: whiteKeySize - blackKeySize,
        ),
        PianoKey.black(
          width: blackKeySize,
          midiNote: octaveStartingNote + 6,
                  flutterMidi: flutterMidi
        ),
        SizedBox(
          width: whiteKeySize - blackKeySize,
        ),
        PianoKey.black(
          width: blackKeySize,
          midiNote: octaveStartingNote + 8,
                  flutterMidi: flutterMidi
        ),
        SizedBox(
          width: whiteKeySize - blackKeySize,
        ),
        PianoKey.black(
          width: blackKeySize,
          midiNote: octaveStartingNote + 10,
                  flutterMidi: flutterMidi
        ),
      ],
    ),
  );
}

}

