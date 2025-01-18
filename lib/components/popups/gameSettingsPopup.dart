import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameOverlay.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';
import 'package:tritac3d/utils/tttGameManagerLocal.dart';
import 'package:tritac3d/utils/tttGameSettings.dart';
import 'package:vibration/vibration.dart';

class Gamesettingspopup extends StatefulWidget {
  final Function(acPopUpTypes type) switchToPopUp;
  final Function(TTTGameManager?) onTTTGameManagerCreation;

  Gamesettingspopup(
      {super.key,
      required this.switchToPopUp,
      required this.onTTTGameManagerCreation});

  @override
  State<Gamesettingspopup> createState() => _GamesettingspopupState();
}

class _GamesettingspopupState extends State<Gamesettingspopup> {
  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context),
        gameController = Provider.of<TTTGameController>(context);
    TTTGameSettings gameSettigns = gameController.getGameSettings();
    return Container(
      margin: appDesign.popupMargin,
      padding: appDesign.popupContainerPadding,
      decoration: BoxDecoration(
        color: appDesign.onBackgroundContainer,
        borderRadius: appDesign.popupContainerRadius,
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
            onChanged: (size) {
              gameSettigns.setGFSize(size.toInt());
              gameController.updateGameSize();
            },
            min: gameSettigns.getMinGFSize().toDouble(),
            max: gameSettigns.getMaxGFSize().toDouble(),
            initValue: gameSettigns.getGFSize().toDouble(),
            description: "gamefield size",
            iconpath: "assets/icons/icon_grid.svg",
            title: "%s x %s x %s",
          ),
          SizedBox(height: 20),
          _settingSlider(
            onChanged: (wins) {
              gameSettigns.setRequiredWins(wins.toInt());
            },
            min: gameSettigns.getMinWins().toDouble(),
            max: gameSettigns.getMaxWins().toDouble(),
            initValue: gameSettigns.getRequiredWins().toDouble(),
            title: "%s x",
            description: "minimum wins",
            iconpath: "assets/icons/icon_crown.svg",
          ),
          SizedBox(height: 20),
          TTTButton(
            onPressed: () {
              widget.switchToPopUp(acPopUpTypes.gameConnection);
            },
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_internetsearch.svg",
                  colorFilter:
                      ColorFilter.mode(appDesign.fontActive, BlendMode.srcIn),
                  height: 44,
                ),
                SizedBox(width: 20),
                Text("ONLINE",
                    style: appDesign.TTTButtonTxtStyle.copyWith(fontSize: 34))
              ],
            ),
          ),
          SizedBox(height: 20),
          TTTButton(
            onPressed: () {
              widget.onTTTGameManagerCreation.call(TTTGameManagerLocal());
              widget.switchToPopUp(acPopUpTypes.gamePlay);
            },
            type: TTTBType.secondary,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_lan.svg",
                  colorFilter:
                      ColorFilter.mode(appDesign.fontActive, BlendMode.srcIn),
                  height: 44,
                ),
                SizedBox(width: 20),
                Text("LOCAL",
                    style: appDesign.TTTButtonTxtStyle.copyWith(fontSize: 34))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _settingSlider extends StatefulWidget {
  final String iconpath;
  final double min;
  final double max;
  late double initValue;

  /// use %s as placeholder for the value
  final String title;
  final String description;
  final Function(double)? onChanged;
  _settingSlider(
      {super.key,
      required this.iconpath,
      this.min = 0,
      this.max = 1,
      this.title = "title",
      this.description = "description",
      this.onChanged,
      double? initValue}) {
    this.initValue = initValue ?? this.min;
  }

  @override
  State<_settingSlider> createState() => _settingSliderState();
}

class _settingSliderState extends State<_settingSlider> {
  late double _value;

  @override
  void initState() {
    _value = widget.initValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    if (_value > widget.max) {
      _value = widget.max;
    }

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
              style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  color: appDesign.fontActive),
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
                          // appDesign.hasVibrator
                          //     ? Vibration.vibrate(duration: 50, amplitude: 64)
                          //     : null;
                          appDesign.vibrateMovement();
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
