//library imports
import 'package:flutter/material.dart';
import 'package:flutter_gpiod/flutter_gpiod.dart';

//entry point for the app
void main() {
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  /// Function for GPIO control
  void ledState(state) {
    /// Retrieve the list of GPIO chips.
    final chips = FlutterGpiod.instance.chips;

    /// Retrieve the line with index 24 of the first chip.
    /// This is BCM pin 24 for the Raspberry Pi.
    final chip = chips.singleWhere(
          (chip) => chip.label == 'pinctrl-bcm2711',
      orElse: () =>
          chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835'),
    );

    final line2 = chip.lines[24];

    /// Request BCM 24 as output.
    line2.requestOutput(consumer: "flutter_gpiod test", initialValue: false);
    line2.setValue(state);
    line2.release();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'LIVING ROOM',
            ),
          ),
        ),
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: Text('ON'),
                onPressed: () {
                  print('ON');
                  ledState(true);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[700],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    textStyle:
                    TextStyle(fontSize: 40, fontWeight: FontWeight.normal)),
              ),
              Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 200,
              ),
              ElevatedButton(
                child: Text('OFF'),
                onPressed: () {
                  print('OFF');
                  ledState(false);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[300],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    textStyle:
                    TextStyle(fontSize: 40, fontWeight: FontWeight.normal)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
