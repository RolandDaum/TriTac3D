import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/utils/appDesign.dart';

// ignore: must_be_immutable
class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  bool darkmode = true;
  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: appDesign.primaryBackground,
      child: Center(
        child: TextButton(
          onPressed: () {
            appDesign.toggleDarkMode();
          },
          child: const Text("Toggle"),
        ),
      ),
    );
  }
}
