import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';

class ScrollSelector extends StatefulWidget {
  final Function(String)? onScroll;
  final List<String> items;

  ScrollSelector({
    super.key,
    this.onScroll,
    this.items = const ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  });

  @override
  ScrollSelectorState createState() => ScrollSelectorState();
}

class ScrollSelectorState extends State<ScrollSelector> {
  final ScrollController _controller = ScrollController();
  final double _height = 100.0;
  final double _width = 50.0;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  // @override
  // void didChangeDependencies() {
  //   // widget.onScroll?.call(widget.items[0]);
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    int selcIdx = (_controller.offset / _height).round();
    if (this.selectedIndex != selcIdx) {
      selectedIndex = selcIdx;
      widget.onScroll?.call(widget.items[selectedIndex]);
    }
  }

  void scrollTo(int index) async {
    if (index < 0 || index > widget.items.length - 1) {
      return;
    }
    selectedIndex = index;
    widget.onScroll?.call(widget.items[index]);
    await _controller.animateTo(
      selectedIndex * _height,
      duration: Duration(milliseconds: 150),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  void _scrollUp() {
    int selcIdx = this.selectedIndex - 1;
    if (selcIdx >= 0) {
      scrollTo(selcIdx);
    } else {
      scrollTo(widget.items.length - 1);
    }
  }

  void _scrollDown() {
    int selcIdx = this.selectedIndex + 1;
    if (selcIdx <= widget.items.length - 1) {
      scrollTo(selcIdx);
    } else {
      scrollTo(0);
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
                children: List.generate(widget.items.length, (index) {
                  return Container(
                    height: _height,
                    width: _width,
                    alignment: Alignment.center,
                    child: Text(
                      widget.items[index],
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
