import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

main() {
  runApp(MaterialApp(home: Scaffold(body: MyScreen())));
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    // Intercept the back button
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    // Remove the interceptor when the screen is disposed
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  // This function is called when the back button is pressed
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back button pressed!");
    // Return true to prevent the default back button action (popping the screen)
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Back Button Interceptor")),
      body: Center(
        child: Text("Press the back button"),
      ),
    );
  }
}
