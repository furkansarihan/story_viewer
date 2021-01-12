import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BlurSlider extends StatefulWidget {
  final String slideToSee;
  final Function onSliderEnd;
  final bool showBlurSlier;
  const BlurSlider({
    Key key,
    this.onSliderEnd,
    this.showBlurSlier,
    this.slideToSee = "",
  }) : super(key: key);

  @override
  _BlurSliderState createState() => _BlurSliderState();
}

class _BlurSliderState extends State<BlurSlider> {
  bool _showing;
  double blur = 60;
  @override
  void initState() {
    _showing = widget.showBlurSlier;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showing) {
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
    return BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.slideToSee,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                child: Slider(
                  min: 5,
                  max: 60,
                  activeColor: Colors.white,
                  inactiveColor: Colors.black12,
                  value: blur,
                  onChanged: (newBlur) {
                    if (!_showing) {
                      return;
                    }
                    if (newBlur == 5) {
                      _showing = false;
                      refreshState();
                      widget?.onSliderEnd();
                      return;
                    }
                    blur = newBlur;
                    refreshState();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refreshState() {
    if (this.mounted) {
      setState(() {});
    }
  }
}
