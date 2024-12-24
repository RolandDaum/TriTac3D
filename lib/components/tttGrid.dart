import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttField.dart';
import 'package:tritac3d/utils/appDesign.dart';

class TTTGrid extends StatefulWidget {
  const TTTGrid({super.key});

  @override
  State<TTTGrid> createState() => _TTTGridState();
}

class _TTTGridState extends State<TTTGrid> {
  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    return Container(
      height: 150 * 2,
      width: 150 * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          border: Border.all(color: appDesign.fontInactive, width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: 9,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0),
        itemBuilder: (context, index) {
          return const TTTField();
        },
      ),
    );
  }
}
