import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';

class Gamesettingspopup extends StatefulWidget {
  const Gamesettingspopup({super.key});

  @override
  State<Gamesettingspopup> createState() => _GamesettingspopupState();
}

class _GamesettingspopupState extends State<Gamesettingspopup> {
  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 40),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: appDesign.onBackgroundContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Settings",
            style: appDesign.TTTButtonTxtStyle,
          ),
          SizedBox(height: 20),
          _settingSlider(
            min: 3,
            max: 6,
            description: "gamefield size",
            iconpath: "assets/icons/icon_grid.svg",
            title: "%s x %s x %s",
          ),
          SizedBox(height: 20),
          _settingSlider(
            min: 1,
            max: 10,
            title: "%s x",
            description: "minimum wins",
            iconpath: "assets/icons/icon_crown.svg",
          ),
          SizedBox(height: 20),
          TTTButton(
            padding: EdgeInsets.symmetric(vertical: 20),
            text: "CONTINUE",
          )
        ],
      ),
    );
  }
}

class _settingSlider extends StatefulWidget {
  final String iconpath;
  final double min;
  final double max;

  /// use %s as placeholder for the value
  final String title;
  final String description;
  final Function(double)? onChanged;
  const _settingSlider(
      {super.key,
      required this.iconpath,
      this.min = 0,
      this.max = 1,
      this.title = "title",
      this.description = "description",
      this.onChanged});

  @override
  State<_settingSlider> createState() => _settingSliderState();
}

class _settingSliderState extends State<_settingSlider> {
  late double _value;

  @override
  void initState() {
    _value = widget.min;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              widget.iconpath,
              height: 24,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.title.replaceAll("%s", _value.toInt().toString()),
              style: TextStyle(fontFamily: "Inter", fontSize: 20),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.description,
            style: TextStyle(color: appDesign.fontInactive, fontSize: 16),
          ),
        ),
        // Maybe move this to the app root in main.dart
        Material(
            type: MaterialType.transparency,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                    canSizeOverlay: true,
                    builder: (context) {
                      return Slider(
                        min: widget.min,
                        max: widget.max,
                        divisions: (widget.max - widget.min).toInt(),
                        value: _value,
                        activeColor: appDesign.fontActive,
                        inactiveColor: appDesign.fontInactive,
                        onChanged: (value) {
                          // TODO: Add vibration / haptic feedback
                          setState(() {
                            _value = value;
                          });
                          widget.onChanged?.call(_value);
                        },
                      );
                    })
              ],
            )),
      ],
    );
  }
}
