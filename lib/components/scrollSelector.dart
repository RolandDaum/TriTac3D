import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';

class ScrollSelector extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final Function(String)? onScroll;
  final List<String> items;
  final double _height = 100.0;
  final double _width = 50.0;

  ScrollSelector({
    this.onScroll,
    this.items = const ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  });

  void _scrollUp() {
    int selectedIndex = (_controller.offset / _height).round();
    if (selectedIndex > 0) {
      selectedIndex--;
      onScroll?.call(items[selectedIndex]);
      _controller.animateTo(
        selectedIndex * _height,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollDown() {
    int selectedIndex = (_controller.offset / _height).round();
    if (selectedIndex < items.length - 1) {
      selectedIndex++;
      onScroll?.call(items[selectedIndex]);
      _controller.animateTo(
        selectedIndex * _height,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return Column(
      children: [
        TTTButton(
          type: TTTBType.secondary,
          onPressed: _scrollUp,
          width: _width,
          height: _width,
          padding: EdgeInsets.all(5),
          child: SvgPicture.asset(
            colorFilter:
                ColorFilter.mode(appDesign.fontActive, BlendMode.srcIn),
            "assets/icons/icon_arrowup.svg",
          ),
        ),
        ClipRect(
          child: SizedBox(
            height: _height,
            width: _width,
            child: SingleChildScrollView(
              controller: _controller,
              physics: PageScrollPhysics(),
              child: Column(
                children: List.generate(items.length, (index) {
                  return Container(
                    height: _height,
                    width: _width,
                    alignment: Alignment.center,
                    child: Text(
                      items[index],
                      style: TextStyle(
                        color: appDesign.fontInactive,
                        fontSize: 40,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        TTTButton(
          type: TTTBType.secondary,
          onPressed: _scrollDown,
          width: _width,
          height: _width,
          padding: EdgeInsets.all(5),
          child: SvgPicture.asset(
            colorFilter:
                ColorFilter.mode(appDesign.fontActive, BlendMode.srcIn),
            "assets/icons/icon_arrowdown.svg",
          ),
        ),
      ],
    );
  }
}
