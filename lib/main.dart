//library imports
import 'package:flutter/material.dart';
import 'package:flutter_gpiod/flutter_gpiod.dart';

//entry point for the app
void main() {
  runApp(MyApp());
}

// This is the main application widget.
class MyApp extends StatelessWidget {
  // Function for GPIO control
  void ledState(state) {
    // Retrieve the list of GPIO chips.
    final chips = FlutterGpiod.instance.chips;

    // Retrieve the line with index 24 of the first chip.
    // This is BCM pin 24 for the Raspberry Pi.
    final chip = chips.singleWhere(
          (chip) => chip.label == 'pinctrl-bcm2711',
      orElse: () =>
          chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835'),
    );

    final line2 = chip.lines[24];

    // Request BCM 24 as output.
    line2.requestOutput(consumer: "flutter_gpiod test", initialValue: false);
    line2.setValue(state);
    line2.release();
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget
    return MaterialApp(
      // Hide the debug banner at the top right corner
      debugShowCheckedModeBanner: false,
      // Scaffold widget
      home: Scaffold(
        // background color of the app.
        // Here after you type "Colors.", Android Studio will recommend the available colors. 
        // Also you can hover the mouse over to check the different color variations assigned 
        // by numbers enclosed by [ ].
        backgroundColor: Colors.grey[700],
        // AppBar widget
        appBar: AppBar(
          // background color of the appbar
          backgroundColor: Colors.black,
          // center align text inside appbar widget
          title: Center(
            child: Text(
              'LIVING ROOM',
            ),
          ),
        ),
        body: Center(
          // Row widge
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ON Button function
              ElevatedButton(
                child: Text('ON'),
                onPressed: () {
                  print('ON');
                  ledState(true);
                },
                // ON Button styling
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[700],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    textStyle:
                    TextStyle(fontSize: 40, fontWeight: FontWeight.normal)),
              ),
              // Google Material Icon of a Light Bulb
              Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 200,
              ),
              // OFF Button function
              ElevatedButton(
                child: Text('OFF'),
                onPressed: () {
                  print('OFF');
                  ledState(false);
                },
                // OFF Button styling
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