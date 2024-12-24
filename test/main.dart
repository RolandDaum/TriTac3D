import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Widget> buildBlurredImage(List<Widget> l) {
    List<Widget> list = [];
    list.addAll(l);
    double sigmaX = 0;
    double sigmaY = 0.1;
    for (int i = 100; i < 350; i += 5) {
      // 100 is the starting height of blur
      // 350 is the ending height of blur
      list.add(Positioned(
        top: i.toDouble(),
        bottom: 0,
        left: 0,
        right: 0,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
      ));
      sigmaX += 0.1;
      sigmaY += 0.1;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            // children: <Widget>[],
            children: buildBlurredImage([
              Container(
                height: 500,
                child: FlutterLogo(size: 1000),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
