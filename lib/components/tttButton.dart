import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/utils/appDesign.dart';

enum TTTBType { primary, secondary }

class TTTButton extends StatefulWidget {
  final double? height;
  final double? width;
  final String text;
  final double? fontSize;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TTTBType type;
  final Widget? child;
  final Function? onPressed;
  TTTButton(
      {super.key,
      this.text = "P L A C E H O L D E R",
      this.height,
      this.width,
      this.fontSize,
      this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      this.margin = const EdgeInsets.all(0),
      this.type = TTTBType.primary,
      this.child,
      this.onPressed});

  @override
  State<TTTButton> createState() => _TTTButtonState();
}

class _TTTButtonState extends State<TTTButton> {
  bool _isPressed = false;
  // TODO: Add vibration / haptic feedback

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed?.call();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: widget.padding,
        margin: widget.margin,
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: _isPressed
              ? (widget.type == TTTBType.primary
                  ? appDesign.accentGreen.withAlpha((255 * 0.8).toInt())
                  : appDesign.onBackgroundContainer
                      .withAlpha((255 * 0.8).toInt()))
              : (widget.type == TTTBType.primary
                  ? appDesign.accentGreen
                  : appDesign.onBackgroundContainer),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.2).toInt()),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
        ),
        transform: _isPressed
            ? Matrix4.translationValues(0, 2, 0)
            : Matrix4.identity(),
        child: Center(
            child: widget.child == null
                ? Text(widget.text,
                    style: appDesign.TTTButtonTxtStyle.copyWith(
                        fontSize: widget.fontSize))
                : widget.child),
      ),
    );
  }
}
